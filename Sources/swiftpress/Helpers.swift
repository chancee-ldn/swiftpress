//
//  Helpers.swift
//  swiftpress
//
//  Created by chancee on 15/12/2019.
//

import Foundation


var configSet = false
var config = Config()

func makeDate(raw: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss z"
    let date = dateFormatter.date(from: raw)
    return date!
}



//  MARK: Generate Config
func generateConfig(data: String) {
    let markdown: String = data
    let parser = MarkdownParser()
    let result = parser.parse(markdown)
    
    guard let url = result.metadata["url"] else { print ("Unable to find url in config"); return   }
    guard let outputDirectory = result.metadata["output"] else { print ("Unable to find output directory in config"); return   }
    guard let templateDirectory = result.metadata["templates"] else { print ("Unable to find a template directory in config"); return   }
    guard let postsDirectory = result.metadata["posts"] else { print ("Unable to find a posts directory in config"); return   }
    guard let postsOutputDirectory = result.metadata["postsOutput"] else { print ("Unable to find a posts directory in config"); return }
    guard let frontpage = Int(result.metadata["frontpage"]!) else { print ("Unable to find a posts directory in config"); return }
    
    let c = Config(url: url, outputDirectory: outputDirectory, templateDirectory: templateDirectory, postsDirectory: postsDirectory, postsOutputDirectory: postsOutputDirectory, frontpage: frontpage)
    config = c
    print ("config set up with an \(config.frontpage) post frontpage")
}


// MARK:    Custom config file
func customConfig(file: String) {
    let path = String(NSString(string: file).expandingTildeInPath)
    do {
        let data = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
        generateConfig(data: data)
        configSet = true
        buildBlog()
    } catch {
        print (error)
    }
}



func buildBlog() {
    
    print (Colours.CORAL + "\nAttempting build..." + Colours.base.rawValue)
    print (Colours.PEACH + "Post directory: " + Colours.base.rawValue + config.postsDirectory)
    print (Colours.PEACH + "Template directory: " + Colours.base.rawValue + config.templateDirectory)
    print (Colours.PEACH + "Output directory: " + Colours.base.rawValue + config.outputDirectory)
    
    writeArchiveList()
    iteratePostDirectory()
    writeFrontPage()
}

//  MARK: Generate post
func makePost(data: String) -> Post {
    let markdown: String = data
    let parser = MarkdownParser()
    let result = parser.parse(markdown)

    let title = result.metadata["title"]!
    let date = makeDate(raw: result.metadata["date"]!)  // NOTE make this a try/catch for a malformed date, if nil, inject current date
    var link = ""
    if result.metadata["link"] != nil {
        link = result.metadata["link"]!
    }
    let body = result.html
    
    let post = Post(title: title, date: date, link: link, body: body)
    return post
}

//  MARK: Archive list
//  Make a list of posts, grouped by month
func returnArchive() -> [Date : [Post]] {
    var archive = [Date : [Post]]()
    
    let posts = returnAllPosts(directory: config.postsDirectory)
    for post in posts {
        // check if the month is empty, if not, append rather than add the post = generating groups
        if archive[post.date] != nil {
            var array = [Post]()
            array.append(post)
            archive[post.date] = array
        } else {
            archive[post.date] = [post]
        }
    }
    return archive
}

func formatArchive() -> String {
    let archive = returnArchive()
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_GB")
    dateFormatter.dateFormat = "MMM yyyy"
    
    let recentPosts = Array(archive.sorted(by: { $0.0 < $1.0 }))[0...(archive.count) - 1]
    let writingsGrouped = recentPosts.categorise { dateFormatter.string(from: $0.value[0].date) }
    print ("\(recentPosts.count) posts across \(writingsGrouped.count) groups \n")
    
    let monthGroups = writingsGrouped.sorted {
        guard let d1 = $0.key.shortDateUK, let d2 = $1.key.shortDateUK else { return false }
        return d1 < d2
    }
    
    var content = ""
    for month in monthGroups.reversed() {
        print (Colours.CORAL + month.key + Colours.base.rawValue)
        // Write the group date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.dateFormat = "MMM yyyy"
        
        let date = dateFormatter.string(from: month.value[0].key)
        let formattedDate = "<h3>\(date)</h3>"
        content.append(formattedDate)
        
        for item in month.value.reversed() {
            for post in item.value {
                print (post.title)
                let headline = "<p><a href=\"posts/\(post.guid()).html\">\(post.title)</a></p>"
                content.append(headline)
            }
        }
    }
    return content
}


func writeArchiveList() {
    
    print (Colours.CORAL + "\nWriting archive list" + Colours.base.rawValue)
    let c = formatArchive()
    
    do {
        let path = String(NSString(string:"\(config.templateDirectory)/archive.template").expandingTildeInPath)
        let template = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
        let content = String(format: template, c)
        let file = String(NSString(string:"\(config.outputDirectory)").expandingTildeInPath + "/posts/index.html")
        do {
            try content.write(toFile: file, atomically: false, encoding: String.Encoding.utf8)
            print (Colours.CORAL + "Frontpage complete, written to: " + Colours.base.rawValue + "\n")
        } catch {
            print ("unable to write post to directory")
        }
    } catch {
        
    }
}


// Return an array of posts to do something else with...
func returnAllPosts(directory: String) -> [Post] {
    var posts = [Post]()
    
    let fileManager = FileManager.default
    let location = String(NSString(string: "\(directory)").expandingTildeInPath)
    let e = fileManager.enumerator(atPath: location)
    
    for file in e! {
        let path = location + "/\(file)"
        let fileString = file as! String
        
        if fileString.first != "." { // if the file does not start with a dot...
            let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
            let post = makePost(data: data!)
            posts.append(post)
        }
    }
    return posts
}


//  MARK: Iterate directory
//  Goes through the specificed directory and outputs HTML via post.template
func iteratePostDirectory() {
    let posts = returnAllPosts(directory: config.postsDirectory)
    print (Colours.CORAL + "\nWriting all posts" + Colours.base.rawValue)
    for post in posts {
        writePostToDirectory(post: post)
    }
    print (Colours.CORAL + "Output \(posts.count) posts to: " + Colours.base.rawValue + config.outputDirectory + "\n")
}



//  MARK: Write front page
//  outputs the most recent config.frontpage of posts to a front page
func writeFrontPage() {
   
    let posts = returnAllPosts(directory: config.postsDirectory)
    
    //  1.  Group the posts
    var postDictionary = [Date: [Post]]()        // All the posts
    for post in posts {
        if postDictionary[post.date] == nil {
            postDictionary[post.date] = [post]
        } else {
            postDictionary[post.date]?.append(post)
        }
    }
    let frontPage = Array(postDictionary.sorted(by: { $0.0 > $1.0 }))[0...config.frontpage]
    var rssPosts = [Post]()     // so we match the number of posts of the frontpage without tracking any variables
    for group in frontPage {
        for post in group.value {
            rssPosts.append(post)
        }
    }
            
    // 2. Make some content
    do {
        let path = String(NSString(string:"\(config.templateDirectory)/index.html").expandingTildeInPath)
        let template = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                
        var c = ""
        for group in frontPage {
            
            // Write the group date
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_GB")
            dateFormatter.dateFormat = "dd MMM yyyy"
            
            let date = dateFormatter.string(from: group.key)
            let formattedDate = "<h3>\(date)</h3>"
            c.append(formattedDate)
            
            // For every post in this grouped set of date:post
            for post in group.value {
                
                if post.link == "" {
                    let headline = "<h2><a href=\"posts/\(post.guid()).html\">\(post.title)</a></h2>"
                    c.append(headline)
                } else {
                    let headline = "<h2><a href=\"\(post.link)\">\(post.title)</a></h2>"
                    c.append(headline)
                }
                c.append(post.body)
                
            }
        }
                
        let d = formatArchive()
        let content = String(format: template, c, d)
        let file = String(NSString(string:"\(config.outputDirectory)").expandingTildeInPath + "/index.html")
        do {
            try content.write(toFile: file, atomically: false, encoding: String.Encoding.utf8)
            print (Colours.CORAL + "Frontpage complete, written to: " + Colours.base.rawValue + "\n")
        }
        catch {
            print ("unable to write post to directory")
        }
        //3. Turn the posts into an RSS feed
        generateRSS(posts: rssPosts)
    } catch {
        print ("\(error)")
    }
    
}


//  MARK: Generate RSS
func generateRSS(posts: [Post]) {
    print (Colours.CORAL + "Generating RSS" + Colours.base.rawValue)
    let path = String(NSString(string:"\(config.templateDirectory)/rss.template").expandingTildeInPath)
    do {
        let template = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
        let currentDateTime = Date()
        
        var items = ""
        for post in posts {
            
            var title = "<item>\n\t<title>%@</title>\n"
            title = String(format: title, post.titleSafe())
                        
            var link = "\t<link>%@</link>\n"
            if post.link.isEmpty {
                link = String(format: link, config.url + "/posts/" + post.guid() + ".html")
            } else {
                link = String(format: link, post.link)
            }
            
            var date = "\t<pubDate>%@</pubDate>\n"
            date = String(format: date, post.date.description)
            
            var guid = "\t<guid>%@</guid>\n"
            guid = String(format: guid, post.guid())
            
            let body = post.body
            
            var description = "\t<description><![CDATA[%@]]>\n</description>\n</item>\n"
            description = String(format: description, String(body))
            
            let p = title + link + date + guid + description
            items.append(p)
        }
        
        let s = String(format: template, currentDateTime.description,  items)
        let file = String(NSString(string:"\(config.outputDirectory)").expandingTildeInPath + "/index.xml")
        do {
            try s.write(toFile: file, atomically: false, encoding: String.Encoding.utf8)
            print (Colours.CORAL + "RSS written to output directory" + Colours.base.rawValue)
        }
        catch {
            print ("unable to write RSS to directory")
        }
    } catch {
        
    }
}


//  MARK: Write Post to Directory
func writePostToDirectory(post: Post) {
    // 1. Filename and directories
    let title = post.guid()
    let path = String(NSString(string:"\(config.templateDirectory)/post.template").expandingTildeInPath)
        
    // 2. Make some content
    do {
        let template = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
        let content = String(format: template, post.ukDate(), post.title, post.body)
        let file = String(NSString(string:"\(config.postsOutputDirectory)").expandingTildeInPath + "/\(title).html")
        do {
            try content.write(toFile: file, atomically: false, encoding: String.Encoding.utf8)
            print (Colours.PASS + "• " + Colours.base.rawValue + "\(file)")
        }
        catch {
            print (Colours.ERROR + "• " + Colours.base.rawValue + "unable to write \(file) to directory")
            print (error)
        }
    } catch {
        print (Colours.ERROR + "• " + Colours.base.rawValue + "unable to access \(path)")
        print ("\(error)")
    }
}

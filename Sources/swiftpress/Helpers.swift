//
//  Helpers.swift
//  swiftpress
//
//  Created by chancee on 15/12/2019.
//

import Foundation


func makeDate(raw: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss z"
    let date = dateFormatter.date(from: raw)
    return date!
}


func makePost(data: String) -> Post {
    let markdown: String = data
    let parser = MarkdownParser()
    let result = parser.parse(markdown)

    let title = result.metadata["title"]!
    let date = makeDate(raw: result.metadata["date"]!)  // NOTE make this a try/catch for a malformed date
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
func writeArchiveList(directory: String, templatePath: String) {
    let templatePath = String(NSString(string:"\(templatePath)").expandingTildeInPath) + "/\("archive.template")"
    var archive = [Date : [Post]]()
    
    print (Colours.CORAL + "\nWriting archive list" + Colours.base.rawValue)
    print (Colours.PEACH + "Post directory: " + Colours.base.rawValue + directory)
    print (Colours.PEACH + "Template directory: " + Colours.base.rawValue + templatePath)

    let posts = returnAllPosts(directory: directory)
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
    
    for month in monthGroups {
        print (Colours.CORAL + month.key + Colours.base.rawValue)
        for item in month.value {
            for post in item.value {
                print (post.title)
            }
        }
    }
    print ("\n")
    
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
func iteratePostDirectory(directory: String, outputDirectory: String, template: String) {
    let posts = returnAllPosts(directory: directory)
    print ("reading \(posts.count) posts from: \(directory)")
    for post in posts {
        writePostToDirectory(post: post, outputDirectory: outputDirectory, template: template)
    }
    print ("wrote \(posts.count) posts")
}



//  MARK: Write front page
//  outputs the most recent x number of posts to a front page
func writeFrontPage(directory: String, outputDirectory: String, templatePath: String, numberOfPosts: Int) {
    let posts = returnAllPosts(directory: directory)
    
    print (Colours.CORAL + "\nWriting front page" + Colours.base.rawValue)
    print (Colours.PEACH + "Post directory: " + Colours.base.rawValue + directory)
    print (Colours.PEACH + "Template directory: " + Colours.base.rawValue + templatePath)
    print (Colours.PEACH + "Output directory: " + Colours.base.rawValue + outputDirectory)
    
    
    //  1.  Group the posts
    var postDictionary = [Date: [Post]]()        // All the posts
    for post in posts {
        if postDictionary[post.date] == nil {
            postDictionary[post.date] = [post]
        } else {
            postDictionary[post.date]?.append(post)
        }
    }
    print (postDictionary.count)
    let frontPage = Array(postDictionary.sorted(by: { $0.0 > $1.0 }))[0...numberOfPosts]
    for group in frontPage {
        for post in group.value {
            print (post.title + " : " + post.date.description)
        }
    }
            
    // 2. Make some content
    do {
        let path = String(NSString(string:"\(templatePath)/index.html").expandingTildeInPath)
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
                    let headline = "<h2><a href=\"posts/\(post.friendlyURL()).html\">\(post.title)</a></h2>"
                    c.append(headline)
                } else {
                    let headline = "<h2><a href=\"\(post.link)\">\(post.title)</a></h2>"
                    c.append(headline)
                }
                c.append(post.body)
                
            }
        }
                
        let content = String(format: template, c)
        let file = String(NSString(string:"\(outputDirectory)").expandingTildeInPath + "/index.html")
        do {
            try content.write(toFile: file, atomically: false, encoding: String.Encoding.utf8)
            print (Colours.CORAL + "Frontpage complete, written to: " + Colours.base.rawValue + outputDirectory + "\n")
        }
        catch {
            print ("unable to write post to directory")
        }
        //3. Turn the posts into an RSS feed
        generateRSS(template: templatePath, output: outputDirectory, posts: posts)
    } catch {
        print ("\(error)")
    }
    
}


//  MARK: Generate RSS
func generateRSS(template: String, output: String, posts: [Post]) {
    print (Colours.CORAL + "Generating RSS" + Colours.base.rawValue)
    let path = String(NSString(string:"\(template)/rss.template").expandingTildeInPath)
    do {
        let template = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
        let currentDateTime = Date()
        
        var items = ""
        for post in posts {
            
            var title = "<item>\n\t<title>%@</title>\n"
            title = String(format: title, post.title)
            title = title.replacingOccurrences(of: "&", with: "&amp;")
            
            
            var link = "\t<link>%@</link>\n"
            link = String(format: link, post.link)
            
            var date = "\t<pubDate>%@</pubDate>\n"
            date = String(format: date, post.date.description)
            let guid = ""
            
            var parser = MarkdownParser()
            let modifier = Modifier(target: .links) { html, markdown in
                var trim = html
                trim = trim.replacingOccurrences(of: "&", with: "&amp;")
                print (trim)
                return trim
            }
            
            parser.addModifier(modifier)
            let body = parser.html(from: post.body)
            
            var description = "\t<description><![CDATA[%@]]>\n</description>\n</item>\n"
            description = String(format: description, String(body))
            
            let p = title + link + date + guid + description
            items.append(p)
        }
        
        let s = String(format: template, currentDateTime.description,  items)
        let file = String(NSString(string:"\(output)").expandingTildeInPath + "/index.xml")
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
func writePostToDirectory(post: Post, outputDirectory: String, template: String) {
    // 1. Filename and directories
    let title = post.friendlyURL()
    let path = String(NSString(string:"\(template)/post.template").expandingTildeInPath)
    print (path)
    
    
    // 2. Make some content
    do {
        let template = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
        let content = String(format: template, post.title, post.date.description, post.body)

        let file = String(NSString(string:"\(outputDirectory)").expandingTildeInPath + "/\(title).html")
        
        print ("writing post to: \(outputDirectory)")
        print (file)
        do {
            try content.write(toFile: file, atomically: false, encoding: String.Encoding.utf8)
            print ("Successfully wrote: \(title)")
        }
        catch {
            print ("unable to write post to directory")
        }
    } catch {
        print ("\(error)")
    }
}

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


// Make a list of posts, grouped by month
func writeArchiveList(postsPath: String, templatePath: String) {
    let templatePath = String(NSString(string:"\(templatePath)").expandingTildeInPath) + "/\("archive.template")"
    print (templatePath)
    
    let fileManager = FileManager.default
    let location = String(NSString(string: "\(postsPath)").expandingTildeInPath)
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_GB")
    dateFormatter.dateFormat = "MMM yyyy"
    var posts = [Date : [Post]]()
    
    if let e = fileManager.enumerator(atPath: location) {
        for file in e {
            let path = location + "/\(file)"
            if let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) {
                // send the data off to a helper to turn into a post we can filter
                let post = makePost(data: data)
                
                // check the date is empty, if not, append rather than add the post - generating groups
                if posts[post.date] != nil {
                    var array = [Post]()
                    array.append(post)
                    posts[post.date] = array
                } else {
                    posts[post.date] = [post]
                }
                print (post.date)
            }
        }
    } else {
        print ("unable to find posts directory")
    }
    
    let recentPosts = Array(posts.sorted(by: { $0.0 < $1.0 }))[0...(posts.count) - 1]
    let writingsGrouped = recentPosts.categorise { dateFormatter.string(from: $0.value[0].date) }
    print (writingsGrouped.count)
    
    let monthGroups = writingsGrouped.sorted {
        guard let d1 = $0.key.shortDateUK, let d2 = $1.key.shortDateUK else { return false }
        return d1 < d2
    }
    
    for month in monthGroups {
        print (Colours.blue + month.key + Colours.base.rawValue)
        for item in month.value {
            for post in item.value {
                print (post.title)
            }
        }
        
    }
}


// Return an array of posts to do something else with...
func returnAllPosts(directory: String) -> [Post] {
    
    var posts = [Post]()
    
    let fileManager = FileManager.default
    let location = String(NSString(string: "\(directory)").expandingTildeInPath)
    let e = fileManager.enumerator(atPath: location)
    
    print ("iterating posts in: \(location)")
    
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


//
//  MARK: Iterate directory
// Goes through the specificed directory and outputs HTML via template 
func iteratePostDirectory(directory: String, outputPath: String, template: String) {
    let posts = returnAllPosts(directory: directory)
    print ("all posts")
    for post in posts {
        // create a post object
        writePostToDirectory(data: post, outputDirectory: outputPath, template: template)
        print ("succesfully wrote: \(post.title)")
    }
}



//  MARK: Write front page
//  outputs the most recent x number of posts to a front "page"
func writeFrontPage(directory: String, outputPath: String, template: String, numberOfPosts: Int) {
    let posts = returnAllPosts(directory: directory)
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
    for group in frontPage.reversed() {
        print (group.key)
        for post in group.value {
            print (post.title)
        }
    }
            
    generateRSS(template: template, output: outputPath, posts: posts)
    
    // 2. Inject data into the template
    let templatePath = String(NSString(string:"\(template)/index.html").expandingTildeInPath)
    do {
        let filename = String(NSString(string:"\(outputPath)").expandingTildeInPath + "/index.html")
        let templateData = try String(contentsOfFile: templatePath, encoding: String.Encoding.utf8)
        var template = templateData.components(separatedBy: "\n")
        
        //  2a. Find the {{post}} tag in the template
        if let id = template.firstIndex(of: "{{posts}}") {
            template.remove(at: id)
            
            // 3. Iterate through the frontpage dictionary
            for group in frontPage.reversed() {
                
                for post in group.value {
                    let body = post.body
                    template.insert(body, at: id)
                    
                    ///
                    if post.link.count > 4 {
                        let headline = "<h2><a href=\"\(post.link)\">\(post.title)</a></h2>"
                        template.insert(headline, at: id)
                    } else {
                        let title = post.title.replacingOccurrences(of: " ", with: "-")
                        let headline = "<h2><a href=\"posts/\(title).html\">\(post.title)</a></h2>"
                        template.insert(headline, at: id)
                    }
                    
                    
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_GB")
                dateFormatter.dateFormat = "dd MMM yyyy"
                
                let date = dateFormatter.string(from: group.key)
                let formattedDate = "<h3>\(date)</h3>"
                template.insert(formattedDate, at: id)
                
            }
            
            // 4. Write the template with data to a file
            let a = template.joined(separator: "")
            do {
                try a.write(toFile: filename, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {
                print ("unable to write file to directory")
            }
            
        } else {
            print ("unable to find {{posts}} tag in template")
        }

    } catch {
        print(error)
    }
}

//  MARK: Generate RSS
func generateRSS(template: String, output: String, posts: [Post]) {
    
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
            //var rfc822 = post.date.description.RFC822Date
            //print ("date: \(rfc822)")
            
            /*
            if let rfc822 = post.date.description.RFC822Date {
                date = String(format: date, rfc822.description)
            } else {
                //print ("date: \(post.date.description.RFC822Date)")
                //print ("raw date: \(post.date)")
                date = String(format: date, post.date.description)
            }
            */
            
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
            //description = String(format: description, "test")
            
            let p = title + link + date + guid + description
            items.append(p)
        }
        
        
        let s = String(format: template, currentDateTime.description,  items)
        let file = String(NSString(string:"\(output)").expandingTildeInPath + "/index.xml")
        do {
            try s.write(toFile: file, atomically: false, encoding: String.Encoding.utf8)
            print ("Successfully wrote RSS to directory")
            print (s)
        }
        catch {
            print ("unable to write RSS to directory")
        }
    } catch {
        
    }
}


//  MARK: Write Post to Directory
func writePostToDirectory(data: Post, outputDirectory: String, template: String) {
    
    // 1. Filename and directories
    let title = data.title.replacingOccurrences(of: " ", with: "-")
    let filename = String(NSString(string:"\(outputDirectory)").expandingTildeInPath + "/\(title).html")
    let templatePath = String(NSString(string:"\(template)").expandingTildeInPath)
    
    // 2. Inject data into the template
    do {
        let templateData = try String(contentsOfFile: templatePath, encoding: String.Encoding.utf8)
        var template = templateData.components(separatedBy: "\n")
        
        if let id = template.firstIndex(of: "{{post}}") {
            template.remove(at: id)
            
            
            let parser = MarkdownParser()
            let body = parser.html(from: data.body)
            template.insert(body, at: id)
            
            
            
            let headline = "<h2>\(data.title)</h2>"
            template.insert(headline, at: id)
            
            let date = data.date
            let formattedDate = "<h3>\(date)</h3>"
            template.insert(formattedDate, at: id)
            
            // 3. Write the template with data to a file
            let a = template.joined(separator: "")
            do {
                try a.write(toFile: filename, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {
                print ("unable to write file to directory")
            }
        } else {
            print ("unable to find {{post}} tag")
        }
    } catch {
        print(error)
    }
}

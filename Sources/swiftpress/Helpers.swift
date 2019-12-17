//
//  Helpers.swift
//  swiftpress
//
//  Created by chancee on 15/12/2019.
//

import Foundation


func makeDate(raw: String) -> Date {
    let array = raw.components(separatedBy: ": ")
    let data = array[1]
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    
    let date = dateFormatter.date(from: data)
    
    return date!
}

// make a title from a markdown document string
func makeTitle(raw: String) -> String {
    let array = raw.components(separatedBy: ": ")
    let data = String(array[1])
    
    return data
}

// wrap a primary link with the posts title
func makeLink(link: String, title: String) -> String {
    let array = link.components(separatedBy: ": ")
    let d = array[1]
    let data = "[\(title)](\(d))"
    return data
}
func makeRawLink(link: String, title: String) -> String {
    let array = link.components(separatedBy: ": ")
    let data = array[1]
    return data
}


func makePost(data: String) -> Post {
    let raw = data.components(separatedBy: "\n")
    let title = makeTitle(raw: (raw[0]))   // title
    let date = makeDate(raw: (raw[1]))     // date
    let link = makeRawLink(link: (raw[5]), title: title)
    var body = [String]()
       var lineIndex = 1
       data.enumerateLines { (line, stop) -> () in
           lineIndex += 1
           if lineIndex >= 8 {
               body.append(line)
           }
       }
    
    let post = Post(title: title, date: date, link: link, body: body.joined(separator: "\n"))
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


func iteratePostDirectory(directory: String) {
    let fileManager = FileManager.default
    let location = String(NSString(string: "\(directory)").expandingTildeInPath)
    let e = fileManager.enumerator(atPath: location)
    
    for file in e! {
        let path = location + "/\(file)"
        let data = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        let arrayIndex = data?.components(separatedBy: "\n")
        
        let title = makeTitle(raw: (arrayIndex?[0])!) // title
        let date = makeDate(raw: (arrayIndex?[1])!)  // date
        var body = [String]()
           var lineIndex = 1
           data?.enumerateLines { (line, stop) -> () in
               lineIndex += 1
               if lineIndex >= 8 {
                   body.append(line)
               }
           }
        let link = makeRawLink(link: (arrayIndex?[5])!, title: title)
        
        // create a post object
        let post = Post(title: title, date: date, link: link, body: body.joined(separator: "\n"))
        writePostToDirectory(data: post, outputDirectory: "~/Production/swiftpress/Tests/writings", templateDirectory: "~/Production/swiftpress/Tests/templates")
        print (post.title)
    }
}


func writePostToDirectory(data: Post, outputDirectory: String, templateDirectory: String) {
    
    // 1. Filename and directories
    let title = data.title.replacingOccurrences(of: " ", with: "-")
    let filename = String(NSString(string:"\(outputDirectory)").expandingTildeInPath + "\(title).html")
    let templatePath = String(NSString(string:"\(templateDirectory)").expandingTildeInPath) + "/\("post.template")"
    
    // 2. Inject data into the template
    do {
        let templateData = try String(contentsOfFile: templatePath, encoding: String.Encoding.utf8)
        var template = templateData.components(separatedBy: "\n")
        
        let id = template.firstIndex(of: "{{post}}")
        template.remove(at: id!)
        
        let date = data.date
        let formattedDate = "<h4>\(date)</h4>"
        template.insert(formattedDate, at: id!)
        
        let headline = "<h5>\(data.title)</h5>"
        template.insert(headline, at: id!)
        
        let parser = MarkdownParser()
        let body = parser.html(from: data.body)
        template.insert(body, at: id!)
        
        // 3. Write the template with data to a file
        let a = template.joined(separator: "")
        do {
            try a.write(toFile: filename, atomically: false, encoding: String.Encoding.utf8)
        }
        catch {
            print ("unable to write file to directory")
        }
    } catch {
        print(error)
    }
}


enum Colours: String {
    case black = "\u{001B}[0;30m"
    case red = "\u{001B}[0;31m"
    case green = "\u{001B}[0;32m"
    case yellow = "\u{001B}[0;33m"
    case blue = "\u{001B}[0;34m"
    case magenta = "\u{001B}[0;35m"
    case cyan = "\u{001B}[0;36m"
    case white = "\u{001B}[0;37m"
    case base = "\u{001B}[0;0m"

    func name() -> String {
        switch self {
        case .black: return "Black"
        case .red: return "Red"
        case .green: return "Green"
        case .yellow: return "Yellow"
        case .blue: return "Blue"
        case .magenta: return "Magenta"
        case .cyan: return "Cyan"
        case .white: return "White"
        case .base: return "Base"
        }
    }

    static func all() -> [Colours] {
        return [.black, .red, .green, .yellow, .blue, .magenta, .cyan, .white, .base]
    }
}

func + (left: Colours, right: String) -> String {
    return left.rawValue + right
}

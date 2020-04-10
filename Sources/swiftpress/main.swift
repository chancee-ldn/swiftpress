import Foundation



public final class CommandLineTool {
    private let arguments: [String]
    private let fileManager = FileManager.default

    public init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }

    var config = Config()
    var configPresent = false
    
    public func run() throws {
        guard arguments.count > 1 else {
            throw Error.missingFileName
        }
        
        if arguments[1] == "-archive" {
            //writeArchiveList(directory: arguments[2], templatePath: arguments[3])
        } else if arguments[1] == "-c" {
            customConfig(file: arguments[2])
        } else if arguments[1] == "-posts" {
            iteratePostDirectory()
            print("Wrote all posts")
        } else if arguments[1] == "-frontpage" {
            //writeFrontPage(directory: arguments[2], outputDirectory: arguments[3], templatePath: arguments[4], numberOfPosts: Int(arguments[5])!)
        } else if arguments[1] == "-h" {
            print ("Write some help text here")
        } else if arguments[1] == "-g" {
            print ("Auto generate")
            generate()
        } else {
            print ("Unknown pipe: \n -posts ~/path/to/directoryOfPosts \n -archive ~/path/to/directoryOfPosts ~/path/to/outputDirectory \n  ")
        }
    }
}

public extension CommandLineTool {
    enum Error: Swift.Error {
        case missingFileName
        case failedToCreateFile
    }
}

let tool = CommandLineTool()

do {
    try tool.run()
} catch {
    print("Whoops! An error occurred: \(error)")
    print ("""
    -posts ~/posts/directory
    -archive ~/path/to/directoryOfPosts ~/path/to/outputDirectory
    -rss will produce an rss feed to index.xml
    """)
    //writeFrontPage(directory: "~/Production/chanc.ee/.drafts", outputPath: "~/Production/chanc.ee", template: "~/Production/chanc.ee/.templates", numberOfPosts: 2)
}




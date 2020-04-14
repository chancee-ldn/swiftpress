import Foundation



public final class CommandLineTool {
    private let arguments: [String]
    private let fileManager = FileManager.default

    public init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }
    
    public func run() throws {
        
        guard arguments.count > 1 else {
            print (Colours.ERROR + "• Need a config file to do things: " + Colours.base.rawValue + "-c /your/configFile.md")
            return
        }
        
        // multiple argument example
        //writeArchiveList(directory: arguments[2], templatePath: arguments[3])
        if arguments[1] == "-archive" {
            //writeArchiveList()
        } else if arguments[1] == "-c" {
            customConfig(file: arguments[2])
        } else if arguments[1] == "-posts" {
            //iteratePostDirectory()
        } else if arguments[1] == "-frontpage" {
            //writeFrontPage()
        } else if arguments[1] == "-h" {
            print ("Write some help text here")
        } else if arguments[1] == "-g" {
            print ("Auto generate")
        } else {
            print ("supply a config file: -c /your/configFile.md")
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
}




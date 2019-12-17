import Foundation



public final class CommandLineTool {
    private let arguments: [String]
    private let fileManager = FileManager.default

    public init(arguments: [String] = CommandLine.arguments) { 
        self.arguments = arguments
    }


    public func run() throws {
        guard arguments.count > 1 else {
            throw Error.missingFileName
        }
        
        if arguments[1] == "-archive" {
            print ("Exporting archive list")
            writeArchiveList(postsPath: arguments[2], templatePath: arguments[3])
            
        } else if arguments[1] == "-posts" {
            print ("parsing a create posts argument")
            iteratePostDirectory(directory: arguments[2])
            
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
}




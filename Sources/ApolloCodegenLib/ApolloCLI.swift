//
//  ApolloCLI.swift
//  ApolloCodegenLib
//
//  Created by Ellen Shapiro on 10/3/19.
//  Copyright © 2019 Apollo GraphQL. All rights reserved.
//

import Foundation

public struct ApolloCLI {
  
  public static func createCLI(scriptsFolderURL: URL) throws -> ApolloCLI {
    let binaryFolderURL = try CLIExtractor.extractCLIIfNeeded(from: scriptsFolderURL)
    return ApolloCLI(binaryFolderURL: binaryFolderURL)
  }
  
  public let binaryFolderURL: URL
  
  public init(binaryFolderURL: URL) {
    self.binaryFolderURL = binaryFolderURL
  }
  
  var scriptPath: String {
    return self.binaryFolderURL.path + "/run"
  }
  
  /// Runs a command with the bundled Apollo CLI
  ///
  /// NOTE: Will always run the `--version` command first for debugging purposes.
  /// - Parameter arguments: The arguments to hand to the CLI
  /// - Parameter folder: The folder to run the command from.
  public func runApollo(with arguments: [String],
                        from folder: URL) throws -> String {
    // Change directories to get into the path to run the script
    let command = "cd \(folder.path)" +
      // Add the binary folder URL to $PATH so the script can find pre-compiled `node`
      " && export PATH=$PATH:\(self.binaryFolderURL.path)" +
      // Log out the version for debugging purposes
      " && \(self.scriptPath) --version" +
      // Set the final command to log out the passed-in arguments for debugging purposes
      " && set -x" +
      // Actually run the script with the given options.
    " && \(self.scriptPath) \(arguments.joined(separator: " "))"
    
    return try Basher.run(command: command, from: folder)
  }
}

//
//  main.swift
//  InnateMCCli
//
//  Created by Shrish Deshpande on 11/18/22.
//

import Foundation
import InnateKit

print("Hello, World!")
#if DEBUG
DataHandler.createTestInstances()
VersionManifest.download()
#endif

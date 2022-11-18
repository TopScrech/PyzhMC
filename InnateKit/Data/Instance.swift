//
//  Instance.swift
//  InnateKit
//
//  Created by Shrish Deshpande on 11/18/22.
//

import Foundation

public struct Instance {
    public var path: URL
    public var name: String
}

extension Instance {
    public func serialize() -> Dictionary<String, Any> {
        [
            "name": name
        ]
    }

    internal static func deserialize(_ dict: Dictionary<String, Any>, path: URL) -> Instance {
        Instance(
                path: path,
                name: dict["name"] as! String
        )
    }

    public static func loadFromDirectory(_ url: URL) -> Instance {
        let plistUrl = url.appendingPathComponent("Instance.plist")
        let dict = DataHandler.loadPlist(plistUrl)
        return deserialize(dict, path: url)
    }
}
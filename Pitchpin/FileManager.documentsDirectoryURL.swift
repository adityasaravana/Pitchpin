//
//  FileManager.documentsDirectoryURL.swift
//  Pitchpin
//
//  Created by Aditya Saravana on 7/9/23.
//


import Foundation

public extension FileManager {
    static var documentsDirectoryURL: URL {
        return `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

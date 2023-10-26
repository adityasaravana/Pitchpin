//
//  DataToFileConverter.swift
//  Pitchpin
//
//  Created by Aditya Saravana on 10/25/23.
//

import Foundation

class DataToFileConverter {
    
    static let shared = DataToFileConverter()
    let fileManager = FileManager.default
    
    var documentDirectoryURL: URL? {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    func convert(using rawData: Data, recordingID: UUID) throws -> URL {
        // Prepare Wav file header
        let waveHeaderFormate = createWaveHeader(data: rawData)
        
        // Prepare Final Wav File Data
        let waveFileData = waveHeaderFormate + rawData
        
        // Store Wav file in document directory.
        return try storeMusicFile(data: waveFileData, id: recordingID)
    }
    
    private func createWaveHeader(data: Data) -> Data {
        var sampleRate: Int32 = 2000
        var chunkSize: Int32 = 36 + Int32(data.count)
        var subChunkSize: Int32 = 16
        var format: Int16 = 1
        var channels: Int16 = 1
        var bitsPerSample: Int16 = 8
        var byteRate: Int32 = sampleRate * Int32(channels * bitsPerSample / 8)
        var blockAlign: Int16 = channels * bitsPerSample / 8
        var dataSize: Int32 = Int32(data.count)
        
        var header = Data()
        
        header.append("RIFF".data(using: .utf8)!)
        header.append(Data(bytes: &chunkSize, count: MemoryLayout.size(ofValue: chunkSize)))
        header.append("WAVE".data(using: .utf8)!)
        header.append("fmt ".data(using: .utf8)!)
        header.append(Data(bytes: &subChunkSize, count: MemoryLayout.size(ofValue: subChunkSize)))
        header.append(Data(bytes: &format, count: MemoryLayout.size(ofValue: format)))
        header.append(Data(bytes: &channels, count: MemoryLayout.size(ofValue: channels)))
        header.append(Data(bytes: &sampleRate, count: MemoryLayout.size(ofValue: sampleRate)))
        header.append(Data(bytes: &byteRate, count: MemoryLayout.size(ofValue: byteRate)))
        header.append(Data(bytes: &blockAlign, count: MemoryLayout.size(ofValue: blockAlign)))
        header.append(Data(bytes: &bitsPerSample, count: MemoryLayout.size(ofValue: bitsPerSample)))
        header.append("data".data(using: .utf8)!)
        header.append(Data(bytes: &dataSize, count: MemoryLayout.size(ofValue: dataSize)))
        
        return header
    }
    
    func storeMusicFile(data: Data, id: UUID) throws -> URL {
        guard let mediaDirectoryURL = documentDirectoryURL else {
            print("Error: Failed to fetch mediaDirectoryURL")
            throw NSError(domain: "Media Directory Unavailable", code: 1, userInfo: nil)
        }
        
        let filePath = mediaDirectoryURL.appendingPathComponent("\(id).wav")
        print("File Path: \(filePath.path)")
        
        try data.write(to: filePath)
        
        return filePath
    }
}

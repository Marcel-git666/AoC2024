//
//  day09.swift
//  AoC2024
//
//  Created by Marcel Mravec on 09.12.2024.
//

import Foundation

enum Day09 {
    static func run() {
        var input: String = ""
        do {
            input = try readFile("day09.input")
        } catch {
            print("Error reading input file.")
        }
        let result = day09Part1(input)
        print(result)
//        print(day09Part2(input))
    }
}

func day09Part1(_ map: String) -> Int {
    var segments: [DiskSegment] = []
    var isFile = true
    var fileId = 0
    for char in map {
        guard let value = Int(String(char)) else { continue }
        if isFile {
            segments.append(DiskSegment(id: fileId, length: value))
            fileId += 1
        } else {
            segments.append(DiskSegment(id: nil, length: value))
        }
        isFile.toggle()
    }
//    print(segments)
    // Initialize indices
    guard let lastFileIndex = segments.lastIndex(where: { $0.id != nil }),
          let freeSpaceIndex = segments.firstIndex(where: { $0.id == nil && $0.length > 0 }) else {
        return calculateChecksum(segments) // If no file or free space exists, calculate checksum immediately
    }
    
    var lastFileIndexVar = lastFileIndex
    var freeSpaceIndexVar = freeSpaceIndex
    
    while hasFreeSpace(segments) {
        //moveBlock(&segments, lastFileIndex: &lastFileIndexVar, freeSpaceIndex: &freeSpaceIndexVar)
        compactDisk(&segments)
    }
    segments.removeAll { $0.length == 0 }
    return calculateChecksum(segments)
}

func calculateChecksum(_ segments: [DiskSegment]) -> Int {
    assert(!segments.contains(where: { $0.id == nil }), "Disk contains free space! Please compact before calculating checksum.")
    
    var index = 0
    var checksum = 0

    for segment in segments {
        if let id = segment.id {
            for _ in 0..<segment.length {
                checksum += id * index
                index += 1
            }
        }
    }

    return checksum
}


func hasFreeSpace(_ segments: [DiskSegment]) -> Bool {
    segments.contains { $0.id == nil && $0.length > 0}
}

func moveBlock(_ segments: inout [DiskSegment], lastFileIndex: inout Int, freeSpaceIndex: inout Int) {
    guard lastFileIndex >= 0, lastFileIndex < segments.count, freeSpaceIndex >= 0, freeSpaceIndex < segments.count else { return }

    let movingID = segments[lastFileIndex].id!
    let blocksToMove = min(segments[freeSpaceIndex].length, segments[lastFileIndex].length)

    segments[freeSpaceIndex].length -= blocksToMove
    segments[lastFileIndex].length -= blocksToMove

    if segments[freeSpaceIndex].length == 0 {
        segments.remove(at: freeSpaceIndex)
        if freeSpaceIndex < lastFileIndex { lastFileIndex -= 1 }
    }

    if segments[lastFileIndex].length == 0 {
        segments.remove(at: lastFileIndex)
        if freeSpaceIndex < lastFileIndex { lastFileIndex -= 1 }
    }

    if freeSpaceIndex < segments.count, segments[freeSpaceIndex].id == movingID {
        segments[freeSpaceIndex].length += blocksToMove
    } else {
        segments.insert(DiskSegment(id: movingID, length: blocksToMove), at: freeSpaceIndex)
    }

    // Recalculate indices
    lastFileIndex = segments.lastIndex(where: { $0.id != nil }) ?? -1
    freeSpaceIndex = segments.firstIndex(where: { $0.id == nil && $0.length > 0 }) ?? -1
}

func compactDisk(_ segments: inout [DiskSegment]) {
    // Initialize indices
    var lastFileIndex = segments.lastIndex(where: { $0.id != nil }) ?? -1
    var freeSpaceIndex = segments.firstIndex(where: { $0.id == nil && $0.length > 0 }) ?? -1

    // Compact the disk
    while freeSpaceIndex >= 0 && lastFileIndex >= 0 {
        // Calculate the number of blocks to move
        let blocksToMove = min(segments[freeSpaceIndex].length, segments[lastFileIndex].length)

        // Update segment lengths
        segments[freeSpaceIndex].length -= blocksToMove
        segments[lastFileIndex].length -= blocksToMove

        // Merge or insert moved blocks
        if segments[freeSpaceIndex].length == 0 {
            segments[freeSpaceIndex].id = segments[lastFileIndex].id
            segments[freeSpaceIndex].length = blocksToMove
        } else {
            segments.insert(DiskSegment(id: segments[lastFileIndex].id, length: blocksToMove), at: freeSpaceIndex)
        }

        // Remove segments if empty
        if segments[lastFileIndex].length == 0 {
            segments.remove(at: lastFileIndex)
            lastFileIndex -= 1
        }
        if segments[freeSpaceIndex].length == 0 {
            segments.remove(at: freeSpaceIndex)
        }

        // Recalculate indices
        freeSpaceIndex = segments.firstIndex(where: { $0.id == nil && $0.length > 0 }) ?? -1
        lastFileIndex = segments.lastIndex(where: { $0.id != nil }) ?? -1
    }
}


struct DiskSegment {
    var id: Int? // `nil` for free space
    var length: Int
}

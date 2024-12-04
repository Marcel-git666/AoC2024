//
//  day04.swift
//  AoC2024
//
//  Created by Marcel Mravec on 04.12.2024.
//

import Foundation

enum Day04 {
    static func run() {
        var input1: String = ""
        do {
            input1 = try readFile("day04.input")
        } catch {
            print("Error reading input file.")
        }
        let result = day04Part1(input1)
        print(result)
        print(day04Part2(input1))
    }
}

func day04Part1(_ input: String) -> Int {
    let directions = [
        (-1, -1), (-1, 0), (-1, 1),  // Top-left, top, top-right
        ( 0, -1),         ( 0, 1),  // Left, right
        ( 1, -1), ( 1, 0), ( 1, 1)  // Bottom-left, bottom, bottom-right
    ]
    let search = Array("MAS")
    var numberOfXmas = 0
    var matrix = [[Character]]()
    
    let lines = input.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
    lines.forEach { line in
        matrix.append(Array(line))
    }
    for row in 0..<matrix.count {
        for col in 0..<matrix[row].count {
            if matrix[row][col] == "X" {
                for direction in directions {
                    var match = true
                    for i in 0..<search.count {
                        let newRow = row + direction.0 * (i + 1)
                        let newCol = col + direction.1 * (i + 1)
                        
                        // Check if the new position is out of bounds
                        if newRow < 0 || newRow >= matrix.count || newCol < 0 || newCol >= matrix[0].count {
                            match = false
                            break
                        }
                        
                        // Check if the character matches
                        if matrix[newRow][newCol] != search[i] {
                            match = false
                            break
                        }
                    }
                    if match {
                        numberOfXmas += 1
                    }
                    
                }
            }
        }
    }
    return numberOfXmas
}

func day04Part2(_ input: String) -> Int {
    
    // search pattern
    //    M.S
    //    .A.
    //    M.S
    
    
    var numberOfXmas = 0
    var matrix = [[Character]]()
    
    let lines = input.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
    lines.forEach { line in
        matrix.append(Array(line))
    }
    for row in 0..<matrix.count {
        for col in 0..<matrix[row].count {
            if matrix[row][col] == "A" {
                // Check if the new position is out of bounds
                if row - 1 < 0 || row + 1 >= matrix.count || col - 1 < 0 || col + 1 >= matrix[0].count {
                    // do nothing
                } else if (matrix[row - 1][col - 1] == "M" && matrix[row + 1][col + 1] == "S" || matrix[row - 1][col - 1] == "S" && matrix[row + 1][col + 1] == "M")
                    &&
                    (matrix[row - 1][col + 1] == "M" && matrix[row + 1][col - 1] == "S" || matrix[row - 1][col + 1] == "S" && matrix[row + 1][col - 1] == "M") {
                    numberOfXmas += 1
                }
            }
        }
    }
    return numberOfXmas
}

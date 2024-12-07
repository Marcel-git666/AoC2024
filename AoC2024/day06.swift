//
//  day06.swift
//  AoC2024
//
//  Created by Marcel Mravec on 06.12.2024.
//

import Foundation

enum Day06 {
    static func run() {
        var input: String = ""
        do {
            input = try readFile("day06.input")
        } catch {
            print("Error reading input file.")
        }
        let result = day06Part1(getMap(input))
        print(result)
        print(day06Part2(getMap(input)))
    }
}

func getMap(_ input: String) -> [[Character]] {
    input.split(separator: "\n").map { line in
        Array(line)
    }
}

func day06Part1(_ input: [[Character]]) -> Int {
    let directions = [
        (-1, 0),    // Top
        ( 0, 1),    // Right
        ( 1, 0),    // Down
        ( 0, -1)    // Left
    ]
    //print(input)
    var map = input
    var row = 0
    var col = 0
    (row, col) = findStartingPosition(map)
    print("Guard is at \(row), \(col) heading \(map[row][col])")
    var directionCounter = 0
    while !(row < 0 || row >= map.count || col < 0 || col >= map[0].count) {
        map[row][col] = "X"
        if row + directions[directionCounter].0 < 0 || row + directions[directionCounter].0 >= map.count || col + directions[directionCounter].1 < 0 ||
            col + directions[directionCounter].1 >= map[0].count {
            break
        }
        if map[row + directions[directionCounter].0][col + directions[directionCounter].1] == "#" {
            directionCounter = (directionCounter + 1) % 4
        }
        row = row + directions[directionCounter].0
        col = col + directions[directionCounter].1
    }
    print(map)
    var sum = 0
    for row in 0..<map.count {
        for col in 0..<map[0].count {
            if map[row][col] == "X" {
                sum += 1
            }
        }
    }
    return sum
}

func findStartingPosition(_ map: [[Character]]) -> (Int, Int) {
    for row in 0..<map.count {
        for col in 0..<map[0].count {
            if map[row][col] == "^" {
                return (row, col)
            }
        }
    }
    return (-1, -1)
}


func day06Part2(_ map: [[Character]]) -> Int {
    var sum = 0
    var rowG = 0
    var colG = 0
    (rowG, colG) = findStartingPosition(map)
    for row in 0..<map.count {
        for col in 0..<map[0].count {
            if (map[row][col] == ".") {
                let modifiedMap = modifyMapAtPosition(map: map, row: row, col: col)
                if checkInfinitePath(input: modifiedMap, rowG: rowG, colG: colG) {
                    sum += 1
                }
            }
        }
    }
    return sum
}

func checkInfinitePath(input: [[Character]], rowG: Int, colG: Int) -> Bool {
    let directions = [
        (-1, 0),    // Top
        ( 0, 1),    // Right
        ( 1, 0),    // Down
        ( 0, -1)    // Left
    ]
    var directionCounter = 0
    var row = rowG
    var col = colG
    var visitedStates = Set<[Int]>() // Track visited states as [row, col, direction]
    
    while !(row < 0 || row >= input.count || col < 0 || col >= input[0].count) {
        let state = [row, col, directionCounter]
        if visitedStates.contains(state) {
            return true // Cycle detected
        }
        visitedStates.insert(state)

        let nextRow = row + directions[directionCounter].0
        let nextCol = col + directions[directionCounter].1

        // Boundary check
        if nextRow < 0 || nextRow >= input.count || nextCol < 0 || nextCol >= input[0].count {
            break
        }

        // Obstruction check
        if input[nextRow][nextCol] == "#" {
            directionCounter = (directionCounter + 1) % 4
        } else {
            row = nextRow
            col = nextCol
        }
    }
    return false
}


func modifyMapAtPosition(map: [[Character]], row: Int, col: Int) -> [[Character]] {
    var modifiedMap = map
    modifiedMap[row][col] = "#"
    return modifiedMap
}

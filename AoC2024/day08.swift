//
//  day08.swift
//  AoC2024
//
//  Created by Marcel Mravec on 08.12.2024.
//

import Foundation

enum Day08 {
    static func run() {
        var input: String = ""
        do {
            input = try readFile("day08.test")
        } catch {
            print("Error reading input file.")
        }
        let result = day08Part1(getCharMap(input))
        print(result)
        print(day08Part2(getCharMap(input)))
    }
}

struct Position: Hashable {
    let x: Int
    let y: Int
}

func day08Part1(_ map: [[Character]]) -> Int {
    //    print(map)
    var antennaPositions: [Character: [(Int, Int)]] = [:]
    
    for row in 0..<map.count {
        for col in 0..<map[row].count {
            let char = map[row][col]
            if char != "." {
                antennaPositions[char, default: []].append((col, row))
            }
        }
    }
    
    var antiNodes: [Position] = []
    
    for pos in antennaPositions {
        if pos.value.count < 2 {
            continue
        }
        for i in 0..<pos.value.count {
            for j in (i + 1)..<pos.value.count {
                let node1 = Position(x: pos.value[i].0, y: pos.value[i].1)
                //                print("Node 1: \(map[node1.y][node1.x]) \(node1)")
                let node2 = Position(x: pos.value[j].0, y: pos.value[j].1)
                //                print("Node 2: \(map[node1.y][node1.x]) \(node2)")
                let (antinode1, antinode2) = calculateAntinodes(node1: node1, node2: node2)
                //                print("Antinodes: \(antinode1), \(antinode2)")
                // Validate and add to antiNodes
                if isValidAntinode(antinode1, map: map) {
                    antiNodes.append(antinode1)
                    //                    print("Antinode 1 is valid")
                }
                if isValidAntinode(antinode2, map: map) {
                    antiNodes.append(antinode2)
                    //                    print("Antinode 2 is valid")
                }
            }
        }
    }
    
    //    var antiMap = map
    //    for node in antiNodes {
    //        antiMap[node.y][node.x] = "#"
    //    }
    //    for row in antiMap {
    //        print(String(row))
    //    }
    return antiNodes.count
}

func isValidAntinode(_ node: Position, map: [[Character]]) -> Bool {
    node.x >= 0 && node.x < map[0].count && node.y >= 0 && node.y < map.count && map[node.y][node.x] == "."
}

func calculateAntinodes(node1: Position, node2: Position) -> (Position, Position) {
    // Calculate the vector direction between the two antennas
    let vectorX = node2.x - node1.x
    let vectorY = node2.y - node1.y
    
    // Calculate antinodes by extending the vector symmetrically
    let antinode1 = Position(
        x: node1.x - vectorX,
        y: node1.y - vectorY
    )
    let antinode2 = Position(
        x: node2.x + vectorX,
        y: node2.y + vectorY
    )
    
    return (antinode1, antinode2)
}

func day08Part2(_ map: [[Character]]) -> Int {
    var antennaPositions: [Character: [(Int, Int)]] = [:]

    // Collect all antenna positions
    for row in 0..<map.count {
        for col in 0..<map[row].count {
            let char = map[row][col]
            if char != "." {
                antennaPositions[char, default: []].append((col, row))
            }
        }
    }

    var antiNodes: Set<Position> = []

    // Add all antennas with more than one entry to antinodes
    for (_, positions) in antennaPositions {
        if positions.count > 1 {
            for position in positions {
                antiNodes.insert(Position(x: position.0, y: position.1))
            }
        }
    }

    // Process pairs of antennas
    for (_, positions) in antennaPositions {
        if positions.count < 2 { continue }

        for i in 0..<positions.count {
            for j in (i + 1)..<positions.count {
                let node1 = Position(x: positions[i].0, y: positions[i].1)
                let node2 = Position(x: positions[j].0, y: positions[j].1)

                let distance = getDistance(node1: node1, node2: node2)

                // Extend the line in both directions
                extendLine(node: node1, vector: distance, antiNodes: &antiNodes, map: map, direction: -1)
                extendLine(node: node2, vector: distance, antiNodes: &antiNodes, map: map, direction: 1)
            }
        }
    }

    return antiNodes.count
}

func getDistance(node1: Position, node2: Position) -> Position {
    // Calculate the vector direction between the two antennas
    return Position(x: node2.x - node1.x, y: node2.y - node1.y)
}

func extendLine(node: Position, vector: Position, antiNodes: inout Set<Position>, map: [[Character]], direction: Int) {
    var multiplier = 1

    while true {
        // Calculate the next position along the line
        let currentNode = Position(
            x: node.x + multiplier * direction * vector.x,
            y: node.y + multiplier * direction * vector.y
        )

        // Stop if the position is out of bounds
        if !isValidAntinode(currentNode, map: map) {
            break
        }

        // Add the valid antinode to the set
        antiNodes.insert(currentNode)
        print("x: \(currentNode.x) y: \(currentNode.y)")
        // Increment the multiplier to extend farther
        multiplier += 1
        print("multiplier: \(multiplier)")
    }
}


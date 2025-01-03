//
//  day12.swift
//  AoC2024
//
//  Created by Marcel Mravec on 18.12.2024.
//

import Foundation

enum Day12 {
    static func run() {
        var input: String = ""
        do {
            input = try readFile("day12.test")
        } catch {
            print("Error reading input file.")
        }
        let result = day12Part1(getCharMap(input))
        print(result)
//        print(day12Part2(getCharMap(input)))
    }
}

func day12Part1(_ map: [[Character]]) -> Int {
    print(map)
    
    return 0
}


func fill(_ input: inout [[Int]], cur: Position, to_fill: Int, countNines: inout Int)
{
    if (cur.y < 0 || cur.y >= input.count || cur.x < 0 || cur.x >= input[0].count || input[cur.y][cur.x] != to_fill) {
        return;
    }
    if input[cur.y][cur.x] == 9 {
        countNines += 1
    }
    input[cur.y][cur.x] = -1;
    fill(&input, cur: Position(x: cur.x - 1, y: cur.y), to_fill: to_fill+1, countNines: &countNines);
    fill(&input, cur: Position(x: cur.x + 1, y: cur.y), to_fill: to_fill+1, countNines: &countNines);
    fill(&input, cur: Position(x: cur.x, y: cur.y - 1), to_fill: to_fill+1, countNines: &countNines);
    fill(&input, cur: Position(x: cur.x, y: cur.y + 1), to_fill: to_fill+1, countNines: &countNines);
}

func floodFill(_ input: [[Int]], startingPosition: Position) -> [[Character]] {
    
    var map: [[Int]] = input
    fill(&map, cur: startingPosition, to_fill: 0, countNines: &countNines)
    return countNines
}

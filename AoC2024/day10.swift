//
//  day10.swift
//  AoC2024
//
//  Created by Marcel Mravec on 10.12.2024.
//

import Foundation

enum Day10 {
    static func run() {
        var input: String = ""
        do {
            input = try readFile("day10.input")
        } catch {
            print("Error reading input file.")
        }
        let result = day10Part1(getIntMap(input))
        print(result)
        print(day10Part2(getIntMap(input)))
    }
}

func day10Part1(_ input: [[Int]]) -> Int {
    print(input)
    var countNines = 0
    let starts = findStartingPoint(input)
    for startHead in starts {
        countNines += findTrailToNine(input, startingPosition: startHead)
    }
    return countNines
}

func findStartingPoint(_ input: [[Int]]) -> [Position] {
    var result: [Position] = []
    
    for row in 0..<input.count {
        for col in 0..<input[row].count {
            if input[row][col] == 0 {
                result.append(Position(x: col, y: row))
            }
        }
    }
    return result
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

func findTrailToNine(_ input: [[Int]], startingPosition: Position) -> Int {
    var countNines: Int = 0
    var map: [[Int]] = input
    fill(&map, cur: startingPosition, to_fill: 0, countNines: &countNines)
    return countNines
}

func getIntMap(_ input: String) -> [[Int]] {
    input.split(separator: "\n").map { line in
        line.map { Int(String($0)) ?? -1 }
    }
}

func day10Part2(_ input: [[Int]]) -> Int {
    print(input)
    var countTrails: Int = 0
    let starts = findStartingPoint(input)
    for startHead in starts {
        countTrails += findTrails(input, startingPosition: startHead)
    }
    return countTrails
}

func findTrails(_ input: [[Int]], startingPosition: Position) -> Int {
    var countTrails: Int = 0
    var visited: Set<Position> = []
    fillTrails(input, cur: startingPosition, to_fill: 0, countTrails: &countTrails, visited: &visited)
    return countTrails
}

func fillTrails(_ input: [[Int]], cur: Position, to_fill: Int, countTrails: inout Int, visited: inout Set<Position>)
{
    if (cur.y < 0 || cur.y >= input.count || cur.x < 0 || cur.x >= input[0].count || input[cur.y][cur.x] != to_fill) {
        return
    }
    if visited.contains(cur) {
        return
    }
    if input[cur.y][cur.x] == 9 {
        countTrails += 1
        return
    }

    fillTrails(input, cur: Position(x: cur.x - 1, y: cur.y), to_fill: to_fill+1, countTrails: &countTrails, visited: &visited)
    fillTrails(input, cur: Position(x: cur.x + 1, y: cur.y), to_fill: to_fill+1, countTrails: &countTrails, visited: &visited)
    fillTrails(input, cur: Position(x: cur.x, y: cur.y - 1), to_fill: to_fill+1, countTrails: &countTrails, visited: &visited)
    fillTrails(input, cur: Position(x: cur.x, y: cur.y + 1), to_fill: to_fill+1, countTrails: &countTrails, visited: &visited)
    visited.remove(cur)
}

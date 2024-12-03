//
//  day01.swift
//  AoC2024
//
//  Created by Marcel Mravec on 01.12.2024.
//

import Foundation

enum Day01 {
    static func run() {
        let input1 = try! readFile("day01.test")
        
        let result = day01Part1(input1)
        print(result)
        print(day01Part2(input1))
    }
}

func day01Part1(_ input: String) -> Int {
    let lines = input.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
    let (a, b) = lines.reduce(into: ([Int](), [Int]())) { result, line in
        let digits = line.split(separator: " ").compactMap { Int($0) }
        if let first = digits.first, let last = digits.last {
            result.0.append(first)
            result.1.append(last)
        }
    }
    let sortedA = a.sorted()
    let sortedB = b.sorted()
    
    let sum = zip(sortedA, sortedB).reduce(0) {total, pair in
        total + abs(pair.1 - pair.0)
    }
    return sum
}
//    let lines = input.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
//    print(lines)
//    var a: [Int] = []
//    var b: [Int] = []
//    for line in lines {
//        let digitString = String(line)
////        print(digitString)
//        let digits = digitString.split(separator: " ").map { Int($0) ?? 0 }
//        a.append(digits.first!)
//        b.append(digits.last!)
//    }
//    a = a.sorted()
//    b = b.sorted()
////    print(a)
////    print(b)
//    var sum = 0
//    for i in 0..<a.count {
//        sum += abs(b[i] - a[i])
//    }
//    
//    return sum
//}

func day01Part2(_ input: String) -> Int {
    let lines = input.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
    let (a, b) = lines.reduce(into: ([Int](), [Int]())) { (result, line) in
        let digits = line.split(separator: " ").compactMap { Int($0) }
        if let first = digits.first, let last = digits.last {
            result.0.append(first)
            result.1.append(last)
        }
    }

    let sim = a.map { c in c * b.filter { $0 == c }.count }.reduce(0, +)
    return sim
}

//func day01Part2(_ input: String) -> Int {
//    let lines = input.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
////    print(lines)
//    var a: [Int] = []
//    var b: [Int] = []
//    for line in lines {
//        let digitString = String(line)
////        print(digitString)
//        let digits = digitString.split(separator: " ").map { Int($0) ?? 0 }
//        a.append(digits.first!)
//        b.append(digits.last!)
//    }
//    var sim = 0
//    for i in 0..<a.count {
//        var c = 0
//        for j in 0..<b.count {
//            if a[i] == b[j] {
//                c += 1
//            }
//        }
//        sim += c * a[i]
//    }
//    
//    return sim
//}


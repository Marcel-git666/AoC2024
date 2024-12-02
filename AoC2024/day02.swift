//
//  day02.swift
//  AoC2024
//
//  Created by Marcel Mravec on 02.12.2024.
//

import Foundation

enum Day02 {
    static func run() {
        let input1 = readFile("day02.input")
        
        let result = day02Part1(input1)
        print(result)
        print(day02Part2(input1))
    }
}

func day02Part1(_ input: String) -> Int {
    let lines = input.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
    print(lines)
    var sum = 0
    lines.forEach { line in
        let report = line.split(separator: " ") .compactMap { Int($0) }
        if checkReport(report) {
            sum += 1
        }
    }
    return sum
}

func checkReport(_ report: [Int]) -> Bool {
    isAscending(report) || isDescending(report)
}

func isAscending(_ report: [Int]) -> Bool {
    for i in 1..<report.count {
        if (report[i] <= report[i-1]) || (report[i] - report[i-1] > 3) || (report[i] - report[i-1] < 1) {
            return false
        }
    }
//    print("\(report) is ascending.")
    return true
}

func isDescending(_ report: [Int]) -> Bool {
    for i in 1..<report.count {
        if report[i] >= report[i-1] || report[i-1] - report[i] > 3 || report[i-1] - report[i] < 1 {
            return false
        }
    }
//    print("\(report) is descending.")
    return true
}

func day02Part2(_ input: String) -> Int {
    let lines = input.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
    print(lines)
    var sum = 0
    lines.forEach { line in
        let report = line.split(separator: " ") .compactMap { Int($0) }
        if checkReportWithError(report) {
            sum += 1
        }
    }
    return sum
}

func checkReportWithError(_ report: [Int]) -> Bool {
    isAscendingWithError(report) || isDescendingWithError(report)
}

func isAscendingWithError(_ report: [Int]) -> Bool {
    if isAscending(report) {
        print("\(report) is ascending.")
        return true
    }
    var i = 0
    var rep = report
    while i < report.count {
        rep.remove(at: i)
        if isAscending(rep) {
            print("\(rep) is ascending.")
            return true
        }
        rep = report
        i += 1
    }
    return false
}

func isDescendingWithError(_ report: [Int]) -> Bool {
    if isDescending(report) {
        print("\(report) is ascending.")
        return true
    }
    var i = 0
    var rep = report
    while i < report.count {
        rep.remove(at: i)
        if isDescending(rep) {
            print("\(rep) is descending.")
            return true
        }
        rep = report
        i += 1
    }
    return false
}
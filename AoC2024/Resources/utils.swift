//
//  utils.swift
//  AoC2024
//
//  Created by Marcel Mravec on 01.12.2024.
//

import Foundation

func readFile(_ name: String) throws -> String {
    let projectURL = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    let fileURL = projectURL.appendingPathComponent(name)
    do {
        let data = try Data(contentsOf: fileURL)
        guard let result = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "FileReadError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to decode file data"])
        }
        return result
    } catch {
        throw NSError(domain: "FileReadError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error reading file: \(error)"])
    }
}

func getCharMap(_ input: String) -> [[Character]] {
    input.split(separator: "\n").map { line in
        Array(line)
    }
}

extension String {
    var lines: [String] {
    split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces) }
    }
}

extension Int {
    init?(_ subString: Substring) {
        guard let int = Int(String(subString)) else { return nil }
            self = int
    }
}

extension String {
    func components(withLength length: Int) -> [String] {
        return stride(from: 0, to: self.count, by: length).map {
            let start = self.index(self.startIndex, offsetBy: $0)
            let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[start..<end])
        }
    }
}

extension Range {
    func contains(otherRange: Range) -> Bool {
        contains(otherRange.lowerBound) && contains(otherRange.upperBound)
    }
}

struct Stack<Element> {
  fileprivate var array: [Element] = []
  
  mutating func push(_ element: Element) {
    array.append(element)
  }
  
  mutating func pop() -> Element? {
    return array.popLast()
  }
  
  func peek() -> Element? {
    return array.last
  }
}

extension Stack: CustomStringConvertible {
  var description: String {
    let topDivider = "---Stack---\n"
    let bottomDivider = "\n-----------\n"
    
    let stackElements = array.map { "\($0)" }.reversed().joined(separator: "\n")
    return topDivider + stackElements + bottomDivider
  }
}

public class TreeNode<T> {
    public var value: T
    public var children: [TreeNode] = []
    public init(_ value: T) {
        self.value = value
    }
}

public class Node<Value> {
    public var value: Value
    public var leftValue: Value
    public var rightValue: Value
    public var left: Node?
    public var right: Node?
    public init(value: Value, leftValue: Value, rightValue: Value, left: Node? = nil, right: Node? = nil) {
        self.value = value
        self.leftValue = leftValue
        self.rightValue = rightValue
        self.left = left
        self.right = right
    }
}

extension Node: Equatable where Value: Equatable {
    public static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.value == rhs.value && lhs.leftValue == rhs.leftValue && lhs.rightValue == rhs.rightValue
    }
}


extension Node: CustomStringConvertible {
    public var description: String {
        guard let left = left else {
            return "\(value)"
        }
        guard let right = right else {
            return "\(value)"
        }
        return "\(value), (\(leftValue), \(rightValue)) -> " + String(describing: left) + ", " + String(describing: right) + " "
    }
}


func permuteWirth<T>(_ a: inout [T], _ n: Int) {
    if n == 0 {
        print(a)   // display the current permutation
    } else {
        permuteWirth(&a, n - 1)
        for i in 0..<n {
            a.swapAt(i, n)
            permuteWirth(&a, n - 1)
            a.swapAt(i, n)
        }
    }
}

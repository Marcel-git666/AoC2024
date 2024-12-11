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
    public var next: Node?
    
    public init(value: Value, next: Node? = nil) {
        self.value = value
        self.next = next
    }
}

extension Node: CustomStringConvertible {
    
    public var description: String {
        guard let next = next else {
            return "\(value)"
        }
        return "\(value) -> " + String(describing: next) + " "
    }
}

public struct LinkedList<Value> {
    
    public var head: Node<Value>?
    public var tail: Node<Value>?
    
    public init() {}
    
    public var isEmpty: Bool {
        head == nil
    }
    
    public mutating func push(_ value: Value) {
        head = Node(value: value, next: head)
        if tail == nil {
            tail = head
        }
    }
    
    public mutating func append(_ value: Value) {

      guard !isEmpty else {
        push(value)
        return
      }
      tail!.next = Node(value: value)
      tail = tail!.next
    }

    public func node(at index: Int) -> Node<Value>? {
        
        var currentNode = head
        var currentIndex = 0
        
        while currentNode != nil && currentIndex < index {
            currentNode = currentNode!.next
            currentIndex += 1
        }
        return currentNode
    }
    
    @discardableResult
    public mutating func insert(_ value: Value, after node: Node<Value>) -> Node<Value> {
        guard tail !== node else {
            append(value)
            return tail!
        }
        node.next = Node(value: value, next: node.next)
        return node.next!
    }
    
    @discardableResult
    public mutating func pop() -> Value? {
        defer {
            head = head?.next
            if isEmpty {
                tail = nil
            }
        }
        return head?.value
    }
    
    @discardableResult
    public mutating func removeLast() -> Value? {
        
        guard let head = head else {
            return nil
        }
        guard head.next != nil else {
            return pop()
        }
        var prev = head
        var current = head
        
        while let next = current.next {
            prev = current
            current = next
        }
        prev.next = nil
        tail = prev
        return current.value
    }
    
    @discardableResult
    public mutating func remove(after node: Node<Value>) -> Value? {
        guard let node = copyNodes(returningCopyOf: node) else { return nil }
        defer {
            if node.next === tail {
                tail = node
            }
            node.next = node.next?.next
        }
        return node.next?.value
    }
    
    private mutating func copyNodes(returningCopyOf node: Node<Value>?) -> Node<Value>? {
        guard !isKnownUniquelyReferenced(&head) else {
            return nil
        }
        guard var oldNode = head else {
            return nil
        }
        
        head = Node(value: oldNode.value)
        var newNode = head
        var nodeCopy: Node<Value>?
        
        while let nextOldNode = oldNode.next {
            if oldNode === node {
                nodeCopy = newNode
            }
            newNode!.next = Node(value: nextOldNode.value)
            newNode = newNode!.next
            oldNode = nextOldNode
        }
        
        return nodeCopy
    }

}

extension LinkedList: Collection {
    
    public struct Index: Comparable {
        
        public var node: Node<Value>?
        
        static public func ==(lhs: Index, rhs: Index) -> Bool {
            switch (lhs.node, rhs.node) {
            case let (left?, right?):
                return left.next === right.next
            case (nil, nil):
                return true
            default:
                return false
            }
        }
        
        static public func <(lhs: Index, rhs: Index) -> Bool {
            guard lhs != rhs else {
                return false
            }
            let nodes = sequence(first: lhs.node) { $0?.next }
            return nodes.contains { $0 === rhs.node }
        }
    }
    public var startIndex: Index {
        Index(node: head)
    }
    public var endIndex: Index {
        Index(node: tail?.next)
    }
    public func index(after i: Index) -> Index {
        Index(node: i.node?.next)
    }
    public subscript(position: Index) -> Value {
        position.node!.value
    }
}

extension LinkedList: CustomStringConvertible {

  public var description: String {
    guard let head = head else {
      return "Empty list"
    }
    return String(describing: head)
  }
}

public class DoubleNode<Value> {
    public var value: Value
    public var leftValue: Value
    public var rightValue: Value
    public var left: DoubleNode?
    public var right: DoubleNode?
    public init(value: Value, leftValue: Value, rightValue: Value, left: DoubleNode? = nil, right: DoubleNode? = nil) {
        self.value = value
        self.leftValue = leftValue
        self.rightValue = rightValue
        self.left = left
        self.right = right
    }
}

extension DoubleNode: Equatable where Value: Equatable {
    public static func == (lhs: DoubleNode, rhs: DoubleNode) -> Bool {
        return lhs.value == rhs.value && lhs.leftValue == rhs.leftValue && lhs.rightValue == rhs.rightValue
    }
}


extension DoubleNode: CustomStringConvertible {
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

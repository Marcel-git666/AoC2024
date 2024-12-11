//
//  day11.swift
//  AoC2024
//
//  Created by Marcel Mravec on 11.12.2024.
//

import Foundation

enum Day11 {
    static func run() async {
        var input: String = ""
        do {
            input = try readFile("day11.test")
            print("File loaded: \(input)")
        } catch {
            print("Error reading input file.")
        }
        let result = day11Part1(getIntArray(input))
        print(result)
        let result2 = await day11Part2Parallel(getIntArray(input), iterations: 5)
        print(result2)
    }
}

func getIntArray(_ input: String) -> [Int] {
    input.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: " ").map { Int(String($0)) ?? -1 }
}

func day11Part1(_ input: [Int]) -> Int {
    print(input)
    var array = input
    for counter in 1...25 {
        if counter % 5 == 0 {
            print("Counter: \(counter), array: \(array.count)")
        }
        var i = 0
        while i < array.count {
            switch array[i] {
            case 0:
                array[i] = 1
            case let value where (Int(log10(Double(value))) + 1) % 2 == 0:
                let digitCount = Int(log10(Double(array[i]))) + 1
                let divisor = Int(pow(10.0, Double(digitCount / 2)))
                let leftHalf = array[i] / divisor
                let rightHalf = array[i] % divisor
                array[i] = rightHalf
                array.insert(leftHalf, at: i)
                i += 1
            default:
                array[i] *= 2024
            }
            i += 1
        }
        // print(array)
    }
    return array.count
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}


func day11Part2Parallel(_ input: [Int], iterations: Int) async -> Int {
    print(input)

    // Split the input into smaller chunks
    let chunks = input.chunked(into: 2) // Adjust chunk size as needed

    // Process each chunk in parallel
    async let results = chunks.map { processChunk($0, iterations: iterations) }

    // Combine results
    return await results.reduce(0, +)
}

func processChunk(_ chunk: [Int], iterations: Int) -> Int {
    var array = chunk
    for _ in 1...iterations {
        var i = 0
        while i < array.count {
            if array[i] == 0 {
                array[i] = 1
            } else if (Int(log10(Double(array[i]))) + 1) % 2 == 0 {
                let digitCount = Int(log10(Double(array[i]))) + 1
                let divisor = Int(pow(10.0, Double(digitCount / 2)))
                let leftHalf = array[i] / divisor
                let rightHalf = array[i] % divisor
                array[i] = rightHalf
                array.insert(leftHalf, at: i)
                i += 1
            } else {
                array[i] *= 2024
            }
            i += 1
        }
    }
    return array.count
}


//func day11Part2(_ input: [Int]) -> Int {
//    print(input)
//    // var linkedLists: [LinkedList<Int>] = []
//    var sum = 0
//    for value in input {
//        var linkedList = LinkedList<Int>()
//        linkedList.append(value)
//        sum += processStone(linkedList)
//    }
//    return sum
//}
//
//func processStone(_ ll: LinkedList<Int>) -> Int {
//    var linkedList = ll
//    for counter in 1...75 {
//        if counter % 5 == 0 {
//            print("Counter: \(counter), ll: \(linkedList.count)")
//        }
//        var current = linkedList.head
//        while current != nil {
//            if current!.value == 0 {
//                // Transform `0` into `1`
//                current!.value = 1
//                current = current?.next
//            } else if (Int(log10(Double(current!.value))) + 1) % 2 == 0 {
//                // Split even-digit number
//                let digitCount = Int(log10(Double(current!.value))) + 1
//                let divisor = Int(pow(10.0, Double(digitCount / 2)))
//                let leftHalf = current!.value / divisor
//                let rightHalf = current!.value % divisor
//                
//                current!.value = leftHalf
//                let newNode = Node(value: rightHalf, next: current?.next)
//                if current === linkedList.tail {
//                    linkedList.tail = newNode // Update tail if needed
//                }
//                current?.next = newNode
//                
//                // Move to the newly inserted node
//                current = newNode.next
//            } else {
//                // Default case: multiply by 2024
//                current!.value *= 2024
//                current = current?.next
//            }
//        }
//    }
//    return linkedList.count
//}

//func day11Part2(_ input: [Int]) -> Int {
//    print(input)
//    var linkedList: LinkedList<Int> = LinkedList()
//    
//    for value in input {
//        linkedList.append(value)
//    }
//    for counter in 1...75 {
//        if counter % 5 == 0 {
//            print("Counter: \(counter), ll: \(linkedList.count)")
//        }
//        var current = linkedList.head
//        while current != nil {
//            if current!.value == 0 {
//                // Transform `0` into `1`
//                current!.value = 1
//                current = current?.next
//            } else if (Int(log10(Double(current!.value))) + 1) % 2 == 0 {
//                // Split even-digit number
//                let digitCount = Int(log10(Double(current!.value))) + 1
//                let divisor = Int(pow(10.0, Double(digitCount / 2)))
//                let leftHalf = current!.value / divisor
//                let rightHalf = current!.value % divisor
//                
//                current!.value = leftHalf
//                let newNode = Node(value: rightHalf, next: current?.next)
//                if current === linkedList.tail {
//                    linkedList.tail = newNode // Update tail if needed
//                }
//                current?.next = newNode
//                
//                // Move to the newly inserted node
//                current = newNode.next
//            } else {
//                // Default case: multiply by 2024
//                current!.value *= 2024
//                current = current?.next
//            }
//        }
//        
//        // print(linkedList.description)
//    }
//    return linkedList.count
//}

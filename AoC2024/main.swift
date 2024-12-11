//
//  main.swift
//  AoC2024
//
//  Created by Marcel Mravec on 01.12.2024.
//

import Foundation

func mainAsync() async {
    await Day11.run()
}

// Keep the program alive until tasks complete
let group = DispatchGroup()
group.enter()

Task {
    await mainAsync()
    group.leave()
}

group.wait()

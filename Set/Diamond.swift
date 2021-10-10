//
//  Diamond.swift
//  Set
//
//  Created by Kris Laratta on 10/10/21.
//

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Start at the center of the rectangle
        let center = CGPoint(x: rect.midX, y: rect.midY)
        // Create the starting point at the right side of the diamond
        let startingPoint = CGPoint(x: rect.maxX, y: center.y)
        // Move from the starting point to the right side of the diamond
        path.move(to: startingPoint)
        
        // Diamond height = distance / 2
        let secondPoint = CGPoint(x: center.x, y: rect.maxY)
        let thirdPoint = CGPoint(x: rect.minX, y: center.y)
        let fourthPoint = CGPoint(x: center.x, y: rect.minY)
        
        path.addLine(to: secondPoint)
        path.addLine(to: thirdPoint)
        path.addLine(to: fourthPoint)
        path.addLine(to: startingPoint)
        
        return path
    }
}

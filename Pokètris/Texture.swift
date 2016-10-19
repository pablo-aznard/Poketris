//
//  Texture.swift
//  Tetris
//
//  Created by Santiago Pavón Gómez on 22/9/16.
//  Copyright © 2016 UPM. All rights reserved.
//

import Foundation
import UIKit

typealias Texture = Int

extension Texture {
    
    static let colorCount = 6
    static let pokemonsCount = 151
    
    func color() -> UIColor {
        
        switch self % Texture.colorCount {
        case 0:
            return UIColor.green
        case 1:
            return UIColor.cyan
        case 2:
            return UIColor.yellow
        case 3:
            return UIColor.magenta
        case 4:
            return UIColor.red
        case 5:
            return UIColor.blue
        default:
            return UIColor.orange
        }
    }
    
    
    func backgroundImageName() -> String {
        return String(format: "bg%d.png", self % Texture.colorCount)
    }
    
    
    func pokemonImageName() -> String {
        return String(format: "%03d.png", self % Texture.pokemonsCount)
    }
    
}

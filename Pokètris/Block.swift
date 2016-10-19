//
//  Block.swift
//  Tetris
//
//  Created by Santiago Pavón Gómez on 22/9/16.
//  Copyright © 2016 UPM. All rights reserved.
//

import Foundation



struct Block {
    
    // Textura del bloque
    fileprivate(set) var texture: Texture
    
    // Forma del Bloque
    fileprivate var shape: [[Bool]]
    
    init(shape: [[Bool]], texture: Texture) {
        self.shape = shape
        self.texture = texture
    }
    
    subscript(row: Int, column: Int) -> Bool {
        return shape[row][column]
    }

    func isSolid(row: Int, column: Int) -> Bool {
        return shape[row][column]
    }
}


// Medidas
extension Block {
    
    // Ancho de un bloque.
    var width: Int {
        return shape[0].count
    }
    
    // Alto de un bloque.
    var height: Int {
        return shape.count
    }
}


// Rotaciones
extension Block {
    
    mutating func rotate(toRight: Bool) {
        if toRight {
            rotateRight()
        } else {
            rotateLeft()
        }
    }

    mutating func rotateRight() {
        var newShape = [[Bool]]()
        for c in 0..<width {
            var newRow = [Bool]()
            for r in 0..<height {
                newRow.insert(shape[r][c], at: 0)
            }
            newShape.append(newRow)
        }
        shape = newShape
    }

    mutating func rotateLeft() {
        var newShape = Array(repeating: Array(repeating: false,
                                              count: height),
                             count: width)
        for c in 0..<width {
            for r in 0..<height {
                newShape[width-c-1][r] = shape[r][c]
            }
        }
        shape = newShape
    }
}


// Crear block aleatorio
extension Block {
    
    static func random() -> Block {
        
        var shape: [[Bool]]
        
        let texture = Int(arc4random_uniform(UInt32(Texture.pokemonsCount)))
        
        switch texture % Texture.colorCount {
        case 0:
            shape = [[false, true, false],
                     [false, true, false],
                     [false, true, false],
                     [false, true, false]]
        case 1:
            shape = [[true, true],
                     [true, true]]
        case 2:
            shape = [[false, true,   false],
                     [true,  true,   true],
                     [false, false,  false]]
        case 3:
            shape = [[false, true, false],
                     [false, true, false],
                     [true,  true, false]]
        case 4:
            shape = [[false, true],
                     [true,  true],
                     [true,  false]]
        default:
            shape = [[true,  false],
                     [true,  true],
                     [false, true]]
        }
        
        var block = Block(shape: shape, texture: texture)
        
        // La rotacion
        switch Int(arc4random_uniform(4)) {
        case 0:
            block.rotateRight()
        case 1:
            block.rotateRight()
            block.rotateRight()
        case 2:
            block.rotateLeft()
        default:
            break
        }
        
        return block
    }
}


extension Block : CustomStringConvertible {
    public var description: String {
        
        let s = shape.map {row in
            row.map {solid in solid ? "X" : "_"}.joined(separator: "")
            }.joined(separator: "\n")
        
        return "Block: \(texture)\n\(s)"
    }
}


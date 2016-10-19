//
//  Board.swift
//  Tetris
//
//  Created by Santiago Pavón Gómez on 22/9/16.
//  Copyright © 2016 UPM. All rights reserved.
//

import Foundation

protocol BoardDelegate : class {
    func rowCompleted()
    func gameOver()
}


class Board {
    
    weak var delegate: BoardDelegate?
    
    let columnsCount = 8
    let rowsCount = 13
    
    private(set) var board: [[Texture?]]
    
    private(set) var nextBlock: Block?
    
    private(set) var currentBlock: Block?
    private(set) var currentBlockColumn: Int = 0
    private(set) var currentBlockRow: Int = 0
    
    init() {

        let row = [Texture?](repeating: nil, count: columnsCount)
        board = [[Texture?]](repeating: row, count: rowsCount)
    }
    
    
    func newGame() {
        
        let row = [Texture?](repeating: nil, count: columnsCount)
        board = [[Texture?]](repeating: row, count: rowsCount)
        
        insertNewBlock()
    }
    
    
    private func insertNewBlock() {
        
        currentBlock = nextBlock ?? Block.random()
        
        currentBlockColumn = columnsCount/2 - currentBlock!.width/2
        currentBlockRow = -1
        
        if onCollision() {
            
            currentBlock = nil
            nextBlock = nil
           
            delegate?.gameOver()
            
        } else {
            nextBlock = Block.random()
        }
    }
    
    
    func rotate(toRight: Bool) {
        
        if currentBlock == nil { return }
            
        let oldBlock = currentBlock
        let oldColumn  = currentBlockColumn
                
        currentBlock!.rotate(toRight: toRight)
        
        while isOutAtLeft() {
            currentBlockColumn += 1
        }
        while isOutAtRight() {
            currentBlockColumn -= 1
        }
        
        if isOutAtBottom() || onCollision() {
            currentBlock = oldBlock
            currentBlockColumn = oldColumn
        }
    }
    
    
    func moveLeft() {

        if currentBlock == nil { return }
        
        currentBlockColumn -= 1
        if isOutAtLeft() || onCollision() {
            currentBlockColumn += 1
        }
    }
    
    func moveRight() {
        
        if currentBlock == nil { return }

        currentBlockColumn += 1
        if isOutAtRight() || onCollision() {
            currentBlockColumn -= 1
        }
    }
    
    func moveDown(insertNewBlockIfNeeded inbin: Bool = false) {
        
        if currentBlock == nil { return }

        currentBlockRow += 1
        if isOutAtBottom() || onCollision() {
            currentBlockRow -= 1
            if inbin {
                addToBoard()
                insertNewBlock()
            }
        }
    }
    
    func dropDown() {
        
        if currentBlock == nil { return }
        
        repeat {
            currentBlockRow += 1
        } while !isOutAtBottom() && !onCollision()
        currentBlockRow -= 1
    }
    
    private func isOutAtLeft() -> Bool {
        
        let width  = currentBlock!.width
        let height = currentBlock!.height
        
        for c in 0..<width where c + currentBlockColumn < 0 {
            for r in 0..<height {
                if currentBlock!.isSolid(row: r, column: c) {
                    return true
                }
            }
        }
        return false
    }
    
    
    private func isOutAtRight() -> Bool {
        
        let width  = currentBlock!.width
        let height = currentBlock!.height
        
        for c in (0..<width).reversed() where c + currentBlockColumn >= columnsCount {
            for r in 0..<height {
                if currentBlock!.isSolid(row: r, column: c) {
                    return true
                }
            }
        }
        return false
    }
    
    
    private func isOutAtBottom() -> Bool {
        
        let width  = currentBlock!.width
        let height = currentBlock!.height
        
        for r in (0..<height).reversed() where r + currentBlockRow >= rowsCount {
            for c in 0..<width {
                if currentBlock!.isSolid(row: r, column: c) {
                    return true
                }
            }
        }
        return false
    }
    
    // Devuelve true si el block actual colisiona con el contenido del Tablero.
    private func onCollision() -> Bool {
                
        let width  = currentBlock!.width
        let height = currentBlock!.height
        
        for r in 0..<height {
            // Ignorar las filas que no han entrado en el tablero
            if r + currentBlockRow < 0 {
                continue
            }
            
            for c in 0..<width {
                if currentBlock!.isSolid(row: r, column: c) {
                    if board[r + currentBlockRow][c + currentBlockColumn] != nil {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    
    private func isRowCompleted(rowIndex: Int) -> Bool {
        for c in 0..<columnsCount {
            if board[rowIndex][c] == nil {
                return false
            }
        }
        return true
    }
    
    
    
    private func removeCompletedRows() {
        for r in (0..<rowsCount).reversed() {
            while isRowCompleted(rowIndex: r) {
                delegate?.rowCompleted()
                compactEmptyRow(rowIndex: r)
            }
        }
    }
    
    private func compactEmptyRow(rowIndex: Int) {
        
        for r in (0..<rowIndex).reversed() {
            board[r + 1] = board[r];
        }
        board[0] =  [Texture?](repeating: nil, count: columnsCount)
    }
    
    
    // Congela/rellena el bloque actual en el tablero
    private func addToBoard() {
        
        let width  = currentBlock!.width
        let height = currentBlock!.height

        for r in 0..<height {
            for c in 0..<width {
                let boardColumn = c + currentBlockColumn
                let boardRow = r + currentBlockRow
                if boardColumn < 0 || boardColumn >= columnsCount ||
                    boardRow < 0 || boardRow >= rowsCount {
                    continue
                }
                if currentBlock!.isSolid(row:r, column:c) {
                    board[boardRow][boardColumn] = currentBlock!.texture
                }
            }
        }
        
        removeCompletedRows()
    }
    
    
    // Devuelve la textura en una posicion del tablero teniendo en cuenta los 
    // bloques que ya estan colocados y el bloque actual.
    func currentTexture(atRow row: Int, atColumn column: Int) -> Texture? {

        // Si hay current block, y la posicion pasada como parametro esta 
        // ocupada por el current bloque y es una posicion solida, entonces
        // devuelvo la textura del bloque, sino devuelvo la textura del fondo.
        if currentBlock != nil,
            column >= currentBlockColumn,
            column < currentBlockColumn + currentBlock!.width,
            row >= currentBlockRow,
            row < currentBlockRow + currentBlock!.height,
            currentBlock![row - currentBlockRow, column - currentBlockColumn] {
            return currentBlock!.texture
        } else {
            return board[row][column]
        }
    }
}



extension Board : CustomStringConvertible {
    public var description: String {
        
        let s = board.map {row in
            row.map {texture in String(format: "%3d", texture ?? -1)}.joined(separator: " ")
            }.joined(separator: "\n")
        
        return "Board:\n\(s)\n\nCurrent: \(currentBlockRow) - \(currentBlockColumn)\n\(currentBlock)\n\nNext:\n\(nextBlock)"
        
    }
}


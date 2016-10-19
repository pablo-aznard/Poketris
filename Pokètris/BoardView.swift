//
//  BoardView.swift
//  Pokètris
//
//  Created by Satan on 10/1/16.
//  Copyright © 2016 1. All rights reserved.
//

import UIKit

protocol BoardViewDataSource: class {
    /// Preguntar al Data Source cuantas filas tiene el tablero a pintar.
    func numberOfRows(in boardView: BoardView) -> Int
    
    /// Preguntar al Data Source cuantas columnas tiene el tablero a pintar.
    func numberOfColumns(in boardView: BoardView) -> Int
    
    /// Preguntar al Data Source que imagen hay que poner como fondo en una posicion del tablero.
    func backgroundImageName(in boardView: BoardView, atRow row: Int, atColumn column: Int) -> UIImage?
    
    /// Preguntar al Data Source que imagen hay que poner en primer plano en una posicion del tablero.
    func foregroundImageName(in boardView: BoardView, atRow row: Int, atColumn column: Int) -> UIImage?
}

class BoardView: UIView {

    weak var dataSource: BoardViewDataSource!
    var boxSize: CGFloat!
    
    @IBInspectable
    var bgColor: UIColor! = UIColor.orange
    
    override func draw(_ rect: CGRect) {
        updateBoxSize()
        drawBackground()
        drawBlocks()
    }
    
    private func drawBackground() {
        
        let rows = dataSource.numberOfRows(in: self)
        let columns = dataSource.numberOfColumns(in: self)
        let canvasX = box2Point(0)
        let canvasY = box2Point(0)
        let canvasWidth = box2Point(columns)
        let canvasHeight = box2Point(rows)
        
        let rect = CGRect(x: canvasX, y: canvasY, width: canvasWidth, height: canvasHeight)
        let path = UIBezierPath(rect: rect)
        
        bgColor.setFill()
        
        path.fill()
    }
    
    private func drawBlocks(){
        
        let rows = dataSource.numberOfRows(in: self)
        let columns = dataSource.numberOfColumns(in: self)
        
        for r in 0..<rows {
            for c in 0..<columns {
                drawBox(row: r, column: c)
            }
        }
    }
    
    private func drawBox(row: Int, column: Int){
        
        
        if let bgImg = dataSource.backgroundImageName(in: self, atRow: row, atColumn: column),
            let fgImg = dataSource.foregroundImageName(in: self, atRow: row, atColumn: column){
            
            let x = box2Point(column)
            let y = box2Point(row)
            let width = box2Point(1)
            let height = box2Point(1)
        
            let rect = CGRect(x: x, y: y, width: width, height: height)
        
            bgImg.draw(in: rect)
            fgImg.draw(in: rect)
        
        }
 
    }
    
    private func updateBoxSize(){
        
        let rows = dataSource.numberOfRows(in: self)
        let columns = dataSource.numberOfColumns(in: self)
        
        let width = bounds.size.width
        let height = bounds.size.height
        
        let boxWidth = width / CGFloat(columns)
        let boxHeight = height / CGFloat(rows)
        
        boxSize = min(boxWidth, boxHeight)
    }
    
    private func box2Point(_ box: Int) -> CGFloat {
        return CGFloat(box) * boxSize
    }


}

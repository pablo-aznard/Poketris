//
//  ViewController.swift
//  Pokètris
//
//  Created by Satan on 10/1/16.
//  Copyright © 2016 1. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BoardViewDataSource {

    
    var board = Board()
    @IBOutlet weak var boardView: BoardView!
    @IBOutlet weak var blockView: BoardView!
    var imagesCache = [String:UIImage]()
    
    var timer: Timer?
    var gameInProgress = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //score.delegate = self
        //board.delegate = self
        
        boardView.dataSource = self
        blockView.dataSource = self
        
        startNewGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func startNewGame(){
        //score.newGame()
        board.newGame()
        gameInProgress = true
        autoMoveDown()
    }
    
    func numberOfRows(in boardView: BoardView) -> Int {
        switch boardView {
        case self.boardView:
            return board.rowsCount
        case self.blockView:
            return board.nextBlock?.height ?? 0
        default:
            return 0
        }
    }
    
    func numberOfColumns(in boardView: BoardView) -> Int {
        switch boardView {
        case self.boardView:
            return board.columnsCount
        case self.blockView:
            return board.nextBlock?.width ?? 0
        default:
            return 0
        }
    }
    
    func backgroundImageName(in boardView: BoardView, atRow row: Int, atColumn column: Int) -> UIImage? {
        switch boardView {
        case self.boardView:
            if let texture = board.currentTexture(atRow: row, atColumn: column){
                let imageName = texture.backgroundImageName()
                return cachedImage(name: imageName)
            }
            
        case self.blockView:
            guard let block = board.nextBlock,
                block.isSolid(row: row, column: column) else {return nil}
            
            let imageName = block.texture.backgroundImageName()
            return cachedImage(name: imageName)
 
        default:
            return nil
        }
        return nil
    }
    
    func foregroundImageName(in boardView: BoardView, atRow row: Int, atColumn column: Int) -> UIImage? {
        switch boardView {
        case self.boardView:
            if let texture = board.currentTexture(atRow: row, atColumn: column) {
                let imageName = texture.pokemonImageName()
                
                return cachedImage(name: imageName)
            }
        case self.blockView:
            if let texture = board.nextBlock?.texture{
                let imageName = texture.pokemonImageName()
                
                return cachedImage(name: imageName)
            }
        default:
            return nil
        }
        return nil

    }
    
    private func cachedImage(name imageName: String) -> UIImage? {
        if let image = imagesCache[imageName] {
            return image
        } else if let image = UIImage(named: imageName) {
            imagesCache[imageName] = image
            return image
        }
        return nil
    }
    
    func autoMoveDown(){
        board.moveDown(insertNewBlockIfNeeded: true)
        boardView.setNeedsDisplay()
        blockView.setNeedsDisplay()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(autoMoveDown), userInfo: nil, repeats: false)
    }

    
    /******************************************************************************/
    /* TRATAMIENTO DE BOTONES                                                     */
    /******************************************************************************/
    @IBAction func moveLeft(_ sender: UIButton) {
        board.moveLeft()
        boardView.setNeedsDisplay()
    }
    
    @IBAction func moveRight(_ sender: UIButton) {
        board.moveRight()
        boardView.setNeedsDisplay()
    }
    
    @IBAction func rotate(_ sender: UIButton) {
        board.rotate(toRight: true)
        boardView.setNeedsDisplay()
    }
    
    @IBAction func rotateLeft(_ sender: UIButton) {
        board.rotate(toRight: false)
        boardView.setNeedsDisplay()
    }
    @IBAction func moveDown(_ sender: UIButton) {
        board.dropDown()
        boardView.setNeedsDisplay()
        blockView.setNeedsDisplay()
    }
    
    
    @IBAction func leftSwipe(_ sender: UISwipeGestureRecognizer) {
        board.moveLeft()
        boardView.setNeedsDisplay()
    }
    
    @IBAction func rightSwipe(_ sender: UISwipeGestureRecognizer) {
        board.moveRight()
        boardView.setNeedsDisplay()
    }
    
    @IBAction func downSwipe(_ sender: UISwipeGestureRecognizer) {
        board.dropDown()
        boardView.setNeedsDisplay()
    }
    
    @IBAction func upSwipe(_ sender: UISwipeGestureRecognizer) {
        board.rotate(toRight: true)
        boardView.setNeedsDisplay()
    }
    
    
    
}

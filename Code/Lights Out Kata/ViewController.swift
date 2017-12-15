//
//  ViewController.swift
//  Lights Out Kata
//
//  Created by Rob Cravens on 6/6/17.
//  Copyright © 2017 Rob Cravens. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var gridView: UIView!
    @IBOutlet weak var mySwitch: UISwitch!
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var UIButtonsView: UIView!
    @IBOutlet weak var columnsTextField: UITextField!
    @IBOutlet weak var rowsTextField: UITextField!
    
    private var touches = [String]()
    private var numOfSolutionTouches = Int()
    
    private var rows = 5
    private var columns = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenBackgroundTouched()
        createButtons()
        
        self.touches.append("User Touched:")
    }

    private func hideKeyboardWhenBackgroundTouched() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.hideKeyboardPressed(_:)))
        gridView.addGestureRecognizer(tapGestureRecognizer)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutButtons()
    }
    
    private func createButtons() {
        for row in 0..<rows {
            for column in 0..<columns {
                createButton(row: row, column: column)
            }
        }
        view.setNeedsLayout()
    }
    
    private func createButton(row: Int, column: Int) {
        let button = KataButton(frame: CGRect.null)
        button.addTarget(self, action:#selector(gridButtonTouched(sender:)), for: .touchUpInside)
        gridView.addSubview(button)
        button.layer.cornerRadius = 14;
        button.clipsToBounds = true
        
        UIButtonsView.layer.cornerRadius = 25
    }
    
    private func layoutButtons() {
        let buttonSize = 28
        let buttonGap = 4
        let xOffset = (gridView.frame.size.width / 2) - CGFloat(((buttonSize + buttonGap) * columns - buttonGap) / 2)
        let yOffset = (gridView.frame.size.height / 2) - CGFloat(((buttonSize + buttonGap) * rows - buttonGap)  / 2)
        for row in 0..<rows {
            for column in 0..<columns {
                let button = buttonAt(row: row, column: column)!
                button.frame = CGRect(x: xOffset + CGFloat(column * (buttonSize + buttonGap)), y: yOffset + CGFloat(row * (buttonSize + buttonGap)), width: CGFloat(buttonSize), height: CGFloat(buttonSize))
            }
        }
    }
    
    @IBAction func rowsChanged(_ sender: UITextField) {
        let rowsText = sender.text!
        if rowsText.count == 0 {
            return
        }
        
        let rowsCount = Int(rowsText)
        if rowsCount == nil {
            return
        }
        
        if rowsCount! > 10 {
            sender.text = String(rowsText.characters.dropLast())
            
            let alert = UIAlertController(title: "Tip", message: "Input a value of 10 or lower", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        rows = rowsCount!
        gridView.subviews.forEach { $0.removeFromSuperview() }
        createButtons()
    }
    
    @IBAction func columnsChanged(_ sender: UITextField) {
        let columnsText = sender.text!
        if columnsText.characters.count == 0 {
            return
        }
        
        let columnsCount = Int(columnsText)
        if columnsCount == nil {
            return
        }
        
        if columnsCount! > 10 {
            sender.text = String(columnsText.characters.dropLast())
            
            let alert = UIAlertController(title: "Tip", message: "Input a value of 10 or lower", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        columns = columnsCount!
        gridView.subviews.forEach { $0.removeFromSuperview() }
        createButtons()
    }
    
    @IBAction func hideKeyboardPressed(_ sender: Any) {
        self.rowsTextField.resignFirstResponder()
        self.columnsTextField.resignFirstResponder()
    }
    
    @IBAction func toggleSwitchChanged(_ sender: Any) {
        if mySwitch.isOn {
            switchLabel.text = "Mode: Plus"
        } else {
            switchLabel.text = "Mode: Single"
        }
    }
    
    @IBAction func gridButtonTouched(sender: KataButton) {
        let r = row(of: sender)
        let c = column(of: sender)
        
        if mySwitch.isOn {
            buttonAt(row: r-1, column: c)?.toggle()
            buttonAt(row: r, column: c-1)?.toggle()
            buttonAt(row: r, column: c)?.toggle()
            buttonAt(row: r, column: c+1)?.toggle()
            buttonAt(row: r+1, column: c)?.toggle()
        } else {
            buttonAt(row: r, column: c)?.toggle()
        }
        let touchedCoordinate = "R:\(row(of: sender)) C:\(column(of: sender))"
        self.touches.append(touchedCoordinate)
    }
    
    func row(of button: UIButton) -> Int {
        let index = gridView.subviews.index(of: button)!
        return index / columns
    }
    
    func column(of button: UIButton) -> Int { 
        let index = gridView.subviews.index(of: button)!
        return index % columns
    }
    
    func buttonAt(row: Int, column: Int) -> KataButton? {
        if row < 0 {
            return nil
        }
        if row >= rows {
            return nil
        }
        
        if column < 0 {
            return nil
        }
        
        if column >= columns {
            return nil
        }
        
        let index = (row * columns) + column
        return gridView.subviews[index] as? KataButton
    }
    
    @IBAction func solveButton(_ sender: Any) {
        if mySwitch.isOn {
            solveHard()
        } else {
            mySwitch.setOn(true, animated: true)
            switchLabel.text = "Mode: Plus"
            solveHard()
        }
    }
    
    //
    func solveHard() {
        self.touches.removeAll()
        self.touches.append("Solution:")

        for row in 0..<rows {
            for column in 0..<columns {
                let button = buttonAt(row: row, column: column)
                button!.wasSelected = button!.isSelected
            }
        }
        
        for index in 0..<32 {
            for column in 0..<columns {
                if index.bitIsOn(column) {
                    gridButtonTouched(sender: buttonAt(row: 0, column: column)!)
                }
            }
            
            solveEasy()
            if isClear() {
                let solutionAlert = UIAlertController(title: "Results:", message: "\(touches)", preferredStyle: UIAlertControllerStyle.alert)
                solutionAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(solutionAlert, animated: true, completion: nil)
                self.touches.removeAll()
                self.touches.append("User Touched:")
                return
            }
            
            for row in 0..<rows {
                for column in 0..<columns {
                    let button = buttonAt(row: row, column: column)
                    button!.isSelected = button!.wasSelected
                }
            }
        }
        
        let canNotSolveAlert = UIAlertController(title: "Alert", message: "This Pattern Can Not Be Solved", preferredStyle: UIAlertControllerStyle.alert)
        canNotSolveAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(canNotSolveAlert, animated: true, completion: nil)
        self.touches.removeAll()
        self.touches.append("User Touched:")
        print("-1")
    }
    
    func solveEasy() {
        for row in 1..<rows {
            for column in 0..<columns {
                let buttonAboveUs = buttonAt(row: row - 1, column: column)
                if buttonAboveUs!.isSelected {
                    gridButtonTouched(sender: buttonAt(row: row, column: column)!)
                    numOfSolutionTouches += 1
                }
            }
        }
    }
    
    func isClear() -> Bool {
        for row in 0..<rows {
            for column in 0..<columns {
                if buttonAt(row: row, column: column)!.isSelected {
                    return false
                }
            }
        }
        return true
    }

}

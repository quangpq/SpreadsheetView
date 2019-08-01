//
//  ViewController.swift
//  SpreadsheetView
//
//  Created by Kishikawa Katsumi on 5/8/17.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import UIKit
import SpreadsheetView

class ViewController: UIViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate {
    @IBOutlet weak var spreadsheetView: SpreadsheetView!
    let weeks = ["Week #14", "Week #15", "Week #16"]
    // Task, Start, Duration, Color
    let tasks = [
        ["Office itinerancy", "2", "17", "0"],
        ["Office facing", "2", "8", "0"],
        ["Interior office", "2", "7", "1"],
        ["Air condition check", "3", "7", "1"],
        ["Furniture installation", "11", "8", "1"],
        ["Workplaces preparation", "11", "8", "2"],
        ["The emproyee relocation", "14", "5", "2"],
        ["Preparing workspace", "14", "5", "1"],
        ["Workspaces importation", "14", "4", "1"],
        ["Workspaces exportation", "14", "3", "0"],
        ["Product launch", "2", "13", "0"],
        ["Perforn Initial testing", "3", "5", "0"],
    ]
    let colors = [UIColor(red: 0.314, green: 0.698, blue: 0.337, alpha: 1),
                  UIColor(red: 1.000, green: 0.718, blue: 0.298, alpha: 1),
                  UIColor(red: 0.180, green: 0.671, blue: 0.796, alpha: 1)]

    override func viewDidLoad() {
        super.viewDidLoad()

        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self

        let hairline = 1 / UIScreen.main.scale
        spreadsheetView.intercellSpacing = CGSize(width: hairline, height: hairline)
        spreadsheetView.gridStyle = .solid(width: hairline, color: .lightGray)

        spreadsheetView.register(HeaderCell.self, forCellWithReuseIdentifier: String(describing: HeaderCell.self))
        spreadsheetView.register(TextCell.self, forCellWithReuseIdentifier: String(describing: TextCell.self))
        spreadsheetView.register(TaskCell.self, forCellWithReuseIdentifier: String(describing: TaskCell.self))
        spreadsheetView.register(ChartBarCell.self, forCellWithReuseIdentifier: String(describing: ChartBarCell.self))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spreadsheetView.flashScrollIndicators()
    }

    // MARK: DataSource

    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 7 * weeks.count
    }

    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return  2 + tasks.count
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        return 50
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        if case 0...1 = row {
            return 28
        } else {
            return 34
        }
    }

    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 0
    }

    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 2
    }

    func mergedCells(in spreadsheetView: SpreadsheetView) -> [CellRange] {
        let weakHeader = weeks.enumerated().map { (index, _) -> CellRange in
            return CellRange(from: (0, index * 7), to: (0, index * 7 + 6))
        }
        let charts = tasks.enumerated().map { (index, task) -> CellRange in
            let start = Int(task[1])!
            let end = Int(task[2])!
            return CellRange(from: (index + 2, start), to: (index + 2, start + end))
        }
        return weakHeader + charts
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        switch (indexPath.column, indexPath.row) {
        case (0..<(7 * weeks.count), 0):
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: HeaderCell.self), for: indexPath) as! HeaderCell
            cell.label.text = weeks[(indexPath.column) / 7]
            cell.gridlines.left = .default
            cell.gridlines.right = .default
            return cell
        case (0..<(7 * weeks.count), 1):
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: HeaderCell.self), for: indexPath) as! HeaderCell
            cell.label.text = String(format: "%02d Apr", indexPath.column + 1)
            cell.gridlines.left = .default
            cell.gridlines.right = .default
            return cell
        case (0..<(7 * weeks.count), 2..<(2 + tasks.count)):
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ChartBarCell.self), for: indexPath) as! ChartBarCell
            
            let start = Int(tasks[indexPath.row - 2][1])!
            if start == indexPath.column {
                cell.label.text = tasks[indexPath.row - 2][0]
                let colorIndex = Int(tasks[indexPath.row - 2][3])!
                cell.color = colors[colorIndex]
            } else {
                cell.label.text = ""
                cell.color = .clear
            }
            
            return cell
        default:
            return nil
        }
    }

    /// Delegate

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: (row: \(indexPath.row), column: \(indexPath.column))")
    }
}

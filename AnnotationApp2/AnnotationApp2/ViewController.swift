//
//  ViewController.swift
//  AnnotationApp2
//
//  Created by 外村真那 on 2022/06/14.
//

import UIKit
import Foundation

class ViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var cuteButton: UIButton!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var lapsTableView: UITableView!
   
    var cal = Calendar(identifier: .gregorian)
    var formatter = DateFormatter()
    var formatter2 = DateComponentsFormatter()
    
    var list : [String] = []
    var str : [String] = []
    var time : [String] = []
    var goodpointTime: Int = 0
    var cutepointTime: Int = 0
    var date1 : Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
}
    
    @IBAction func time(_ sender: Any) {
        formatter.dateFormat = "HH:mm:ss"
        let nowTime = formatter.string(from: NSDate() as Date)
        date1 = Date()
        list.append(nowTime)
        str.append("開始時間")
        lapsTableView.reloadData()
    }
    
    @IBAction func stopButtontapped(_ sender: Any) {
        formatter.dateFormat = "HH:mm:ss"
        let nowTime = formatter.string(from: NSDate() as Date)
        list.append(nowTime)
        str.append("終了時間")
        lapsTableView.reloadData()
    }
    
    @IBAction func goodButtontapped(_ sender: Any) {
        formatter.dateFormat = "HH:mm:ss"
        let nowTime = formatter.string(from: NSDate() as Date)
        list.append(nowTime)
        goodpointTime += 1
        str.append("いいねポイント\(goodpointTime)")
        let date2 = Date()
        let diff = cal.dateComponents([.second], from: date1, to: date2)
        formatter2.unitsStyle = .positional
        formatter2.allowedUnits = [.hour, .minute, .second]
        time.append(formatter2.string(from: diff)!)
        lapsTableView.reloadData()
    }
    
    @IBAction func cuteButtontapped(_ sender: Any) {
        formatter.dateFormat = "HH:mm:ss"
        let nowTime = formatter.string(from: NSDate() as Date)
        list.append(nowTime)
        cutepointTime += 1
        str.append("きゅんきゅんポイント\(cutepointTime)")
        let date2 = Date()
        let diff = cal.dateComponents([.second], from: date1, to: date2)
        formatter2.unitsStyle = .positional
        formatter2.allowedUnits = [.hour, .minute, .second]
        time.append(formatter2.string(from: diff)!)
        lapsTableView.reloadData()
    }
    
    @IBAction func copyButtontapped(_ sender: Any) {
        var data = [String]()
        str.removeFirst(1)
        str.removeLast(1)
        for (str, list) in zip(str, list) {
            data.append("\(str),\(list)")
    }
        UIPasteboard.general.string = data.joined(separator: "\n")
        
    }
    
    @IBAction func showButtontapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toSecond", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let nextVC = segue.destination as! NextViewController
            
        nextVC.list2 = list
        nextVC.str2 = str
        nextVC.time2 = time
        
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style:.value1 , reuseIdentifier:"Cell")
        cell.textLabel?.text = str[indexPath.row]
        cell.detailTextLabel?.text = list[indexPath.row]
        return cell
    }
    
    
}

//
//  NextViewController.swift
//  AnnotationApp2
//
//  Created by 外村真那 on 2022/06/16.
//

import UIKit

class NextViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    
    var list2 = [String]()
    var str2 = [String]()
    var time2 = [String]()
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        str2.removeFirst(1)
        str2.removeLast(1)
        for (str2, time2) in zip(str2, time2) {
            data.append("\(str2),\(time2)")
        }
        textLabel.text = data.joined(separator: "\n")
    }
    
    @IBAction func copyButtontapped(_ sender: Any) {
        UIPasteboard.general.string = data.joined(separator: "\n")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

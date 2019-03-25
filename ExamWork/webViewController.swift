//
//  webViewController.swift
//  ExamWork
//
//  Created by Вадим Гатауллин on 25/03/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import UIKit
import WebKit

class webViewController: UIViewController, WKUIDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.uiDelegate = self
        let url = URL(string: "http://www.sourcefreeze.com");
        let requestObj = URLRequest(url: url!);
        webView.load(requestObj);

        // Do any additional setup after loading the view.
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

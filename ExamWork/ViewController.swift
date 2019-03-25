//
//  ViewController.swift
//  ExamWork
//
//  Created by Вадим Гатауллин on 25/03/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import UIKit
import CoreData

struct Human {
    var name: String
    var surname: String
    var subsurName: String
    
    init(n: String, sur: String, sub: String) {
        self.name = n
        self.surname = sur
        self.subsurName = sub
    }
}

class myTableViewController: UIViewController {
    @IBOutlet weak var myTableView: UITableView!
    
    var humans: [Human] = []
    var userDef = UserDefaults()
    let contView = UIView(frame: CGRect(x: 20 , y: 50 , width: 200 , height: 200))
    
    var image: UIImage? {
        didSet {
            self.image = self.image?.resizeImage(image: self.image!, targetSize: CGSize(width: 200, height: 200))
            let imageview = UIImageView(image: self.image)
            contView.addSubview(imageview)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
            button.backgroundColor = .green
            button.setTitle("closeButton", for: .normal)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            contView.addSubview(button)
            self.view.addSubview(contView)
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        self.contView.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        
        self.view.backgroundColor = userDef.backgroundColor ?? UIColor.white
        self.generateUsers()
    }
    
    func generateUsers() {
        let hum1 = Human(n: "Лев", sur: "Львова", sub: "ЛЬвович")
        let hum2 = Human(n: "Иван", sur: "Иванов", sub: "Иванович")
        let hum3 = Human(n: "Кукусь", sur: "Кукусов", sub: "Кукусович")
        
        self.humans.append(hum1)
        self.humans.append(hum2)
        self.humans.append(hum3)
    }
    
    @IBAction func refreshColorButtonClicked(_ sender: Any) {
        self.view.backgroundColor = UIColor.random
        userDef.backgroundColor = self.view.backgroundColor
        
    }
    @IBAction func imageButtonClicked(_ sender: Any) {
        let urlString = "https://images.pexels.com/photos/853199/pexels-photo-853199.jpeg?cs=srgb&dl=4k-wallpaper-background-beautiful-853199.jpg&fm=jpg?dl&fit=crop&crop=entropy&w=6000&h=4000"
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }
    @IBAction func webButtonClicked(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "webViewController") as! webViewController
        self.present(newViewController, animated: true, completion: nil)
    }
}
extension myTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return humans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myTableViewCell", for: indexPath) as! myTableViewCell
        cell.configure(human: humans[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "HumanViewController") as! HumanViewController
        newViewController.initDelegate(del: self)
        newViewController.initHuman(hum: self.humans[indexPath.row], index: indexPath.row)
        self.present(newViewController, animated: true, completion: nil)
    }
    
}
extension myTableViewController: savingSurName {

    
    func saveNewSurName(newSur: String, index: Int) {
        self.humans[index].surname = newSur
        self.myTableView.reloadData()
    }
    
}

extension UserDefaults {
    func set(_ color: UIColor?, forKey defaultName: String) {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        guard let color = color, color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            else {
                removeObject(forKey: defaultName)
                return
        }
        let count = MemoryLayout<CGFloat>.size
        set(Data(bytes: &red,   count: count) +
            Data(bytes: &green, count: count) +
            Data(bytes: &blue,  count: count) +
            Data(bytes: &alpha, count: count), forKey: defaultName)
    }
    func color(forKey defaultName: String) -> UIColor? {
        guard let data = data(forKey: defaultName) else {
            return nil
        }
        let size = MemoryLayout<CGFloat>.size
        return UIColor(red:   data[size*0..<size*1].withUnsafeBytes{ $0.pointee },
                       green: data[size*1..<size*2].withUnsafeBytes{ $0.pointee },
                       blue:  data[size*2..<size*3].withUnsafeBytes{ $0.pointee },
                       alpha: data[size*3..<size*4].withUnsafeBytes{ $0.pointee })
    }
    var backgroundColor: UIColor? {
        get {
            return color(forKey: "backgroundColor")
        }
        set {
            set(newValue, forKey: "backgroundColor")
        }
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}

extension UIImage {
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}




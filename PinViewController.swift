//
//  PinViewController.swift
//  iBillboard
//
//  Created by Harrison Voslow on 11/7/16.
//  Copyright © 2016 Harrison Voslow. All rights reserved.
//

import UIKit
import CoreData

class PinViewController: UIViewController, UITextViewDelegate {
    
    //var pin: Pin = Pin(t:"",d:"")
    //var pin: NSManagedObject = NSManagedObject()
    var pinIndex: Int = 0;
    var pins = [NSManagedObject]()
    var titleText: String = ""
    var descText: String = ""
    
    let imageView = UIImageView(frame: CGRect(x: 60, y:70, width:200, height:200))
    //imageView.center = self.view.center
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //let temp: String = (pins[pinIndex].value(forKey: "title") as? String)!
        self.navigationItem.title = "Edit Pin"
        print("Begin of code")
        if let checkedUrl = URL(string: "http://i.imgur.com/6eKLtVC.jpg") {
            imageView.contentMode = .scaleAspectFit
            downloadImage(url: checkedUrl)
        }
        print("End of code. The image will continue downloading in the background and it will be loaded when it ends.")
        
        
        
        //Stuff
        let myColor : UIColor = UIColor.lightGray
        let nameTextField: UITextField = UITextField(frame: CGRect(x: self.view.center.x - 100, y: 275, width: 200.00, height: 40.00));
        nameTextField.layer.borderWidth = 1;
        nameTextField.layer.borderColor = myColor.cgColor
        nameTextField.textAlignment = .center;
        
        
        let descLabel: UILabel = UILabel(frame: CGRect(x: self.view.center.x - 100, y: 315, width: 200.00, height: 40.00));
        descLabel.text = "Description: "
        
        
        let descTextField: UITextView = UITextView(frame: CGRect(x: self.view.center.x - 100, y: 355, width: 200.00, height: 160.00));
        descTextField.layer.borderWidth = 1;
        descTextField.layer.borderColor = myColor.cgColor;
        descTextField.text = (pins[pinIndex].value(forKey: "desc") as? String)!
        descText = (pins[pinIndex].value(forKey: "desc") as? String)!
        descTextField.delegate = self
        nameTextField.text = (pins[pinIndex].value(forKey: "title") as? String)!
        titleText = (pins[pinIndex].value(forKey: "title") as? String)!
        nameTextField.addTarget(self, action: #selector(PinViewController.didChangeText(textField:)), for: .editingChanged);
        self.view.addSubview(descTextField)
        self.view.addSubview(nameTextField)
        self.view.addSubview(descLabel)
        
        let saveButton: UIButton = UIButton(frame: CGRect(x: self.view.center.x - 50, y: 520, width: 100.00, height: 40.00));
        saveButton.setTitle("SAVE", for: UIControlState.normal);
        saveButton.backgroundColor = UIColor.blue;
        saveButton.addTarget(self, action: #selector(PinViewController.buttonPress(saveButton:)), for: .touchUpInside);
        self.view.addSubview(saveButton);
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PinViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func didChangeText(textField: UITextField) {
        //your code
        //bucketItem.name = textField.text!;
        titleText = textField.text!;
        print(textField.text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        //bucketItem.description = textView.text!;
        descText = textView.text!;
        print(textView.text);
    }
    
    func buttonPress(saveButton: UIButton){
        performSegue(withIdentifier: "SaveEditsSegue", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Functionality taken from http://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                self.imageView.image = UIImage(data: data)
                self.view.addSubview(self.imageView)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveEditsSegue"{
            let PinTableViewController = segue.destination as! PinTableViewController
            pins[pinIndex].setValue(titleText, forKey: "title")
            pins[pinIndex].setValue(descText, forKey: "desc")
            PinTableViewController.pins = self.pins
            PinTableViewController.currentIndex = 0
            PinTableViewController.tableView.reloadData();
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

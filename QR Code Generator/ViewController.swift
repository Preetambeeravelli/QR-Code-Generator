//
//  ViewController.swift
//  QR Code Generator
//
//  Created by Preetam Beeravelli on 2/1/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        inputTextField.delegate = self
        view.endEditing(true)
        
    }

    @IBAction func shareButtonPressed(_ sender: UIButton) {
        
        var sharableImage = UIImage()
        var qrCodeGenerated = qrCodeImageView.image
        
        if qrCodeGenerated == nil{
            present(alertGenerator(with: "Generate a QR Code before sharing"), animated: true)
            return
        }
        
        if  qrCodeGenerated != nil {
            sharableImage = qrCodeImageView.image!
        }
        
        let activityController = UIActivityViewController(activityItems: [sharableImage], applicationActivities: nil)
             activityController.popoverPresentationController?.sourceView = self.view
             self.present(activityController, animated: true)
         
    }
    
    @IBAction func generateButtonPressed(_ sender: UIButton) {
        
        let inputTextByUser = inputTextField.text
       
        if inputTextByUser?.count == 0{
            self.present(alertGenerator(with: "Type something before generating a qr code"), animated: true)
            return
        }
        if let inputTextByUser = inputTextByUser{
            print(inputTextByUser)
            fetchQRCode(with: inputTextByUser)
        }
        
        
        
    }
    
    func fetchQRCode(with text: String){
        
        clearQRCode()
        var replacedStringWithPlus = text.replacingOccurrences(of: " ", with: "+")
    
        let headers = [
            "X-RapidAPI-Key": "f6ee0c68d2msh5dc8d420ea2fc54p124243jsnf1320cd64a90",
            "X-RapidAPI-Host": "getqrcode.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://getqrcode.p.rapidapi.com/api/getQR?forQR=\(replacedStringWithPlus)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                guard let data else {return}
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.qrCodeImageView.image = image
                }
            }
        })

        dataTask.resume()
        clearTextField()
    }
    
    
}
//MARK: - TextField Delegate Methods

extension ViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if inputTextField.text?.count == 0{
            self.present(alertGenerator(with: "Type something before generating a qr code"), animated: true)
            return false
        }
 //       fetchQRCode(with: inputTextField.text!)
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    
}

//MARK: - Functions
extension ViewController{
    
    func clearQRCode(){
        if qrCodeImageView.image != nil{
                self.qrCodeImageView.image = nil
        }
    }
    
    func clearTextField(){
        inputTextField.text = ""
    }
    
    
    func alertGenerator(with message: String) -> UIAlertController{
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        return alert
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


//
//  ViewController.swift
//  TestLibreria
//
//  Created by Jesus  Santaella on 21/01/21.
//

import UIKit
import ForjaLib

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var nuevaConexion=ForjaLib()
    var resultado:String="OCR"
    @IBOutlet weak var imageData: UIImageView!
    
    @IBOutlet weak var titulo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        titulo.text=nuevaConexion.getURL()
    }

    @IBAction func Frontal(_ sender: Any) {
        nuevaConexion.setURL(nueva: "https://wp8mrbv9qd.execute-api.us-east-1.amazonaws.com/prod/frontal/")
        nuevaConexion.tipoOtro()
        print(nuevaConexion.getURL())
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker,animated: true,completion: nil)
        }else{
            print("No se pudo acceder al carrete de imagenes")
        }
    }
    @IBAction func Reverso(_ sender: Any) {
        nuevaConexion.setURL(nueva: "https://wp8mrbv9qd.execute-api.us-east-1.amazonaws.com/prod/reverso/")
        nuevaConexion.tipoOtro()
        print(nuevaConexion.getURL())
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker,animated: true,completion: nil)
        }else{
            print("No se pudo acceder al carrete de imagenes")
        }
    }
    
    @IBAction func Selfie(_ sender: Any) {
        nuevaConexion.setURL(nueva: "https://wp8mrbv9qd.execute-api.us-east-1.amazonaws.com/prod/ine-selfie/")
        nuevaConexion.tipoSelfie()
        nuevaConexion.setFaceId(nuevoFaceid: "123121312414")
        print(nuevaConexion.getURL())
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker,animated: true,completion: nil)
        }else{
            print("No se pudo acceder al carrete de imagenes")
        }
    }
    
    @IBAction func Comprobante(_ sender: Any) {
        nuevaConexion.setURL(nueva: "https://wp8mrbv9qd.execute-api.us-east-1.amazonaws.com/prod/cfe/")
        nuevaConexion.tipoOtro()
        print(nuevaConexion.getURL())
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker,animated: true,completion: nil)
        }else{
            print("No se pudo acceder al carrete de imagenes")
        }
    }
    
    
    //Función del sistema para obtener la imagen capturada del uiimage
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.imageData.image = pickedImage
            let _:NSData = pickedImage.pngData()! as NSData
            //Convertir a base64
            let strBase64 = ConvertImageToBase64String(img: pickedImage)
            nuevaConexion.setImagen(nuevaImagen: strBase64)
                self.nuevaConexion.crearConexion {
                salida in
                print(salida)
                //RECUPERA DEL HILO EL VALOR DE SALIDA
                DispatchQueue.main.async {
                    self.cambiarTexto(nuevo: salida)
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func cambiarTexto(nuevo:String){
        titulo.text=nuevo
    }
    func ConvertImageToBase64String (img: UIImage) -> String {
        let imageData:NSData = img.jpegData(compressionQuality: 0.50)! as NSData //UIImagePNGRepresentation(img)
        let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
        return imgString
    }
    
}


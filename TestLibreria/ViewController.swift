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
        nuevaConexion.setURL(nueva: "https://d2qx3bqvr4h3ci.cloudfront.net/frontal/")
        nuevaConexion.tipoOtro()
        print(nuevaConexion.getURL())
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker,animated: true,completion: nil)
        }else{
            print("No se pudo acceder a la camara")
        }
    }
    @IBAction func Reverso(_ sender: Any) {
        nuevaConexion.setURL(nueva: "https://d2qx3bqvr4h3ci.cloudfront.net/reverso/")
        nuevaConexion.tipoOtro()
        print(nuevaConexion.getURL())
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker,animated: true,completion: nil)
        }else{
            print("No se pudo acceder a la camara")
        }
    }
    
    @IBAction func Selfie(_ sender: Any) {
        nuevaConexion.setURL(nueva: "https://d2qx3bqvr4h3ci.cloudfront.net/ine-selfie/")
        nuevaConexion.tipoSelfie()
        nuevaConexion.setFaceId(nuevoFaceid: "123121312414")
        print(nuevaConexion.getURL())
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.cameraDevice = .front
            imagePicker.allowsEditing = true
            self.present(imagePicker,animated: true,completion: nil)
        }else{
            print("No se pudo acceder a la camara")
        }
    }
    
    @IBAction func Comprobante(_ sender: Any) {
        nuevaConexion.setURL(nueva: "https://d2qx3bqvr4h3ci.cloudfront.net/cfe/")
        nuevaConexion.tipoOtro()
        print(nuevaConexion.getURL())
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker,animated: true,completion: nil)
        }else{
            print("No se pudo acceder a la camara")
        }
    }
    
    
    //Función del sistema para obtener la imagen capturada del uiimage
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.imageData.image = pickedImage
            let _:NSData = pickedImage.pngData()! as NSData
            self.cambiarTexto(nuevo: "Procesando...")
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
        let targetSize = CGSize(width: 300, height: 200)
               let widthScaleRatio = targetSize.width / img.size.width
               let heightScaleRatio = targetSize.height / img.size.height
               
               let scaleFactor = min(widthScaleRatio, heightScaleRatio)
               
               let scaledImageSize = CGSize(
                   width: img.size.width * scaleFactor,
                   height: img.size.height * scaleFactor
               )
               let renderer = UIGraphicsImageRenderer(
                          size: scaledImageSize
                      )

                      let scaledImage = renderer.image { _ in
                          img.draw(in: CGRect(
                              origin: .zero,
                              size: scaledImageSize
                          ))
                      }
        let imageData:NSData = scaledImage.jpegData(compressionQuality: 0.10)! as NSData //UIImagePNGRepresentation(img)
        let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
        return imgString
    }
    
}


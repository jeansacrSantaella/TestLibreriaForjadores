//
//  ViewController.swift
//  TestLibreria
//

import UIKit
import ForjaLib

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var nuevaConexion=ForjaLib()
    var resultado:String="OCR"
    var comprobante:Bool=false
    //Variable auxiliar para poder entender cuando debe entrar y buscar el valor del selfie id
    var selfie:Bool=false
    var faceID:String=""
    
    //Declaración del contenedor de la imagen
    @IBOutlet weak var imageData: UIImageView!
    
    @IBOutlet weak var titulo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nuevaConexion.setURL(nueva: "https://d2qx3bqvr4h3ci.cloudfront.net/frontal/")
        titulo.text=nuevaConexion.getURL()
    }

    @IBAction func Frontal(_ sender: Any) {
        //Se asigna una nueva Ruta
        nuevaConexion.setURL(nueva: "https://d2qx3bqvr4h3ci.cloudfront.net/frontal/")
        nuevaConexion.tipoOtro()
        self.comprobante=false
        self.selfie=true
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
        //Se asigna la nueva Ruta
        nuevaConexion.setURL(nueva: "https://d2qx3bqvr4h3ci.cloudfront.net/reverso/")
        nuevaConexion.tipoOtro()
        print(nuevaConexion.getURL())
        self.comprobante=false
        self.selfie=false
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
        print(nuevaConexion.getURL())
        self.comprobante=false
        self.selfie=false
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
        self.comprobante=true
        self.selfie=false
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
        if let pickedImage1 = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.imageData.image = pickedImage1
            //Esta función sirve para quitar valores EXIF
            let pickedImage = pickedImage1.fixedOrientation()
            // para cortar la imagen cuando, es recomendable usarlo con selfie, ine frontal y reverso
            //Hace que se muestre un recuadro en el centro de la imagen y recorta todo lo que quede fuera de el.
             /*if let img = info[.editedImage] as? UIImage {
                self.dataImage.image = img
                } else if let img = info[.originalImage] as? UIImage {
                    self.dataImage.image = img
                }
            //Girar imagen si es necesario., el giro se da en radianes
                //rotar imagen es en radianes
                self.dataImage.image = self.dataImage.image?.rotate(radians: 4.71239)
                //self.dataImage.image = self.dataImage.image?.rotate(radians: 1.5708)
            */
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
                    //Sección de codigo para recuperar FACEID
                    if(self.selfie){
                    var replaced = salida.replacingOccurrences(of: "[{\"resultado\":", with: "")
                    replaced = replaced.replacingOccurrences(of: "}]", with: "")
                    let jsre=replaced.toDictionary()
                    let res = jsre["FACE_ID"]
                    let str1 = String (describing: res)
                                    let str0 = str1.replacingOccurrences(of: "Optional({", with: "")
                                    let str = str0.replacingOccurrences(of: "VALOR =", with:"")
                                    let str2 = str.replacingOccurrences(of: ";", with: "")
                                    let str3 = str2.replacingOccurrences(of: "})", with: "")
                                    let trimed = str3.trimmingCharacters(in: .whitespacesAndNewlines)
                                    let integer = Int(trimed) ?? 0
                                    self.faceID=trimed
                            print(trimed)
                        self.nuevaConexion.setFaceId(nuevoFaceid: trimed)
                                    print (integer)
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func cambiarTexto(nuevo:String){
        titulo.text=nuevo
    }
    func ConvertImageToBase64String (img: UIImage) -> String {
        //Redimensiona la imagen al tamaño deseado
        let targetSize = CGSize(width: 1200, height: 800)
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
        //reduce la calidad de la imagen , maximo. soportado 10
        let imageData:NSData = scaledImage.jpegData(compressionQuality: 0.1)! as NSData //UIImagePNGRepresentation(img)
        let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
        //print(imgString)
        return imgString
    }
}
extension UIImage {
    func fixedOrientation() -> UIImage {
        // No realiza accion alguna si la imagen ya esta correctamente orientada
        if (imageOrientation == UIImage.Orientation.up) {
            return self
        }
        // Necesitamos calcular la transformación adecuada para enderezar la imagen.
        // Lo hacemos en 2 pasos: rotar si es Izquierda / Derecha / Abajo, y luego voltear si está Reflejado.
        var transform:CGAffineTransform = CGAffineTransform.identity
        if (imageOrientation == UIImage.Orientation.down
                || imageOrientation == UIImage.Orientation.downMirrored) {
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
        }
        if (imageOrientation == UIImage.Orientation.left
                || imageOrientation == UIImage.Orientation.leftMirrored) {

            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
        }
        if (imageOrientation == UIImage.Orientation.right
                || imageOrientation == UIImage.Orientation.rightMirrored) {
            transform = transform.translatedBy(x: 0, y: size.height);
            transform = transform.rotated(by: CGFloat(-M_PI_2));
        }
        if (imageOrientation == UIImage.Orientation.upMirrored
                || imageOrientation == UIImage.Orientation.downMirrored) {

            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        if (imageOrientation == UIImage.Orientation.leftMirrored
                || imageOrientation == UIImage.Orientation.rightMirrored) {

            transform = transform.translatedBy(x: size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }
        // Ahora dibujamos la CGImage subyacente en un nuevo contexto, aplicando la transformación
        // calculado anteriormente.
        let ctx:CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height),
                                      bitsPerComponent: cgImage!.bitsPerComponent, bytesPerRow: 0,
                                      space: cgImage!.colorSpace!,
                                      bitmapInfo: cgImage!.bitmapInfo.rawValue)!
        ctx.concatenate(transform)
        if (imageOrientation == UIImage.Orientation.left
                || imageOrientation == UIImage.Orientation.leftMirrored
                || imageOrientation == UIImage.Orientation.right
                || imageOrientation == UIImage.Orientation.rightMirrored
            ) {
            ctx.draw(cgImage!, in: CGRect(x:0,y:0,width:size.height,height:size.width))
        } else {
            ctx.draw(cgImage!, in: CGRect(x:0,y:0,width:size.width,height:size.height))
        }
        // Y ahora solo creamos una nueva imagen de UII a partir del contexto de dibujo
        let cgimg:CGImage = ctx.makeImage()!
        let imgEnd:UIImage = UIImage(cgImage: cgimg)

        return imgEnd
    }
    //Función para rotar la imagen se recibe en radianes
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }
        return self
    }
}

extension String{
    //Auxiliar para parsear json respuesta
   func toDictionary() -> NSDictionary {
       let blankDict : NSDictionary = [:]
       if let data = self.data(using: .utf8) {
           do {
               return try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
           } catch {
               print(error.localizedDescription)
           }
       }
       return blankDict
   }
}



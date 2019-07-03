import UIKit
import Photos
import Vision

class ViewController: UIViewController {

    enum ObjcetType {
        case face
        case rectangle
        case text
    }
    
    private var image: UIImage?
    private var objcetType: ObjcetType = .face
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapButton(_ sender: Any) {
        let alert = UIAlertController(title: "検出するオブジェクト", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "顔検出", style: .default) { [weak self] (_) in
            self?.objcetType = .face
            self?.presentPickerVC()
        })
        alert.addAction(UIAlertAction(title: "矩形検出", style: .default) { [weak self] (_) in
            self?.objcetType = .rectangle
            self?.presentPickerVC()
        })
        alert.addAction(UIAlertAction(title: "テキスト検出", style: .default) { [weak self] (_) in
            self?.objcetType = .text
            self?.presentPickerVC()
        })
        present(alert, animated: true, completion: nil)
    }
    
    private func presentPickerVC() {
        let vc = UIImagePickerController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dismiss(animated: true, completion: nil)

        image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        guard let cgImage = image?.cgImage else { return }
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            switch objcetType {
            case .face:
                try requestHandler.perform([detectFaceRectanglesRequest()])
            case .rectangle:
                try requestHandler.perform([detectRectanglesRequest()])
            case .text:
                try requestHandler.perform([detectTextRectanglesRequest()])
            }
        } catch {
            print(error)
        }
    }

    private func detectTextRectanglesRequest() -> VNDetectTextRectanglesRequest {
        let request = VNDetectTextRectanglesRequest { [weak self] (request, error) in
            
            guard let observations = request.results as? [VNTextObservation] else { return }
            for observation in observations {
                self?.image = self?.drawMark(image: self?.image, boundingBox: observation.boundingBox)
            }
            self?.imageView.image = self?.image
        }
        return request
    }

    private func detectRectanglesRequest() -> VNDetectRectanglesRequest {
        let request = VNDetectRectanglesRequest { [weak self] (request, error) in
            
            guard let observations = request.results as? [VNRectangleObservation] else { return }
            for observation in observations {
                self?.image = self?.drawMark(image: self?.image, boundingBox: observation.boundingBox)
            }
            self?.imageView.image = self?.image
        }
        request.maximumObservations = 5
        request.quadratureTolerance = 10
        return request
    }

    private func detectFaceRectanglesRequest() -> VNDetectFaceRectanglesRequest {
        let request = VNDetectFaceRectanglesRequest { [weak self] (request, error) in
            
            guard let observations = request.results as? [VNFaceObservation] else { return }
            for observation in observations {
                self?.image = self?.drawMark(image: self?.image, boundingBox: observation.boundingBox)
            }
            self?.imageView.image = self?.image
        }
        return request
    }
    
    private func drawMark(image: UIImage?, boundingBox: CGRect) -> UIImage? {
        guard let imageSize = image?.size else { return nil }
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        image?.draw(in: CGRect(origin: .zero, size: imageSize))
        context?.setLineWidth(12.0)
        context?.setStrokeColor(UIColor.green.cgColor)
        context?.stroke(boundingBox.converted(to: imageSize))
        let drawnImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return drawnImage
    }
}

extension CGRect {
    func converted(to size: CGSize) -> CGRect {
        return CGRect(x: self.minX * size.width,
                      y: (1 - self.maxY) * size.height,
                      width: self.width * size.width,
                      height: self.height * size.height)
    }
}

import UIKit
import Vision
import VisionKit

class ViewController: UIViewController {

    @IBOutlet weak var cardNumberTextField: UITextField!
    
    @IBOutlet weak var expireTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapScanButton(_ sender: Any) {
        let vc = VNDocumentCameraViewController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
}


extension ViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        
        dismiss(animated: true, completion: nil)
        
        if scan.pageCount <= 0 { return }
        let image = scan.imageOfPage(at: 0)
        guard let cgImage = image.cgImage else { return }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try requestHandler.perform([reuqest()])
        } catch {
            print(error)
        }
    }
    
    private func reuqest() -> VNRecognizeTextRequest {
        let request = VNRecognizeTextRequest { [weak self] (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            var cardNumber = ""
            var expire = ""
            for observation in observations {
                guard let candidate = observation.topCandidates(1).first else { continue }
                let line = candidate.string.replacingOccurrences(of: " ", with: "")
                if let _ = Int(line), line.count == 16 {
                    cardNumber = candidate.string
                }
                
                if let range = candidate.string.range(of: "\\d\\d/\\d\\d", options: .regularExpression, range: nil, locale: nil) {
                    expire = String(candidate.string[range])
                }
            }
            
            print("### \(cardNumber)")
            print("### \(expire)")
            self?.cardNumberTextField.text = "\(cardNumber)"
            self?.expireTextField.text = "\(expire)"
        }
        request.recognitionLevel = .accurate
        
        return request
    }
}

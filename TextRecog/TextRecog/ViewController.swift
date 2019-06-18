import UIKit
import Vision
import VisionKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cardNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapScanStartButton(_ sender: Any) {
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
        let request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            var text = ""
            for observation in observations {
                guard let candidate = observation.topCandidates(1).first else { continue }
                text += candidate.string + "\n"
            }
            
            self.cardNumberLabel.text = text
        }
        request.recognitionLevel = .accurate

        return request
    }
}


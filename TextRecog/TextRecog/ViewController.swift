import UIKit
import Vision
import VisionKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = VNRecognizeTextRequest { (request, error) in
            //
        }
        request.recognitionLevel = .accurate
        
    }
    
    @IBAction func didTapScanStartButton(_ sender: Any) {
        let vc = VNDocumentCameraViewController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
}

extension ViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        //
    }
}


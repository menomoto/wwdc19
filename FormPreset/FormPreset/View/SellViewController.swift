import UIKit
import Vision
import Photos

class SellViewController: UIViewController {

    private var image: UIImage?
    private var recognizedText: String?
    
    enum CellType: Int, CaseIterable {
        case image
        case plain
        case title
        case description
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "ImagesCell", bundle: nil), forCellReuseIdentifier: "ImagesCell")
            tableView.register(UINib(nibName: "TextViewCell", bundle: nil), forCellReuseIdentifier: "TextViewCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "出品フォーム"
        
        let langs = try! VNRecognizeTextRequest.supportedRecognitionLanguages(for: .fast, revision: VNRecognizeTextRequestRevision1)
        print("######## revision: \(VNRecognizeTextRequestRevision1)")
        print("######## langs: \(langs)")
    }
    
    private func createImagePickerVC() {
        let vc = UIImagePickerController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
}

extension SellViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = CellType(rawValue: indexPath.row)!
        switch cellType {
        case .image:
            return 80
        case .title, .plain:
            return 44
        case .description:
            return 300
        }
    }
}

extension SellViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = CellType(rawValue: indexPath.row)!
        switch cellType {
        case .image:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImagesCell", for: indexPath) as? ImagesCell else { return UITableViewCell() }
            cell.set(image: image) { [weak self] in
                self?.createImagePickerVC()
            }
            return cell
        case .plain:
            let cell = UITableViewCell()
            cell.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            return cell
        case .title, .description:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell", for: indexPath) as? TextViewCell else { return UITableViewCell() }
            cell.set(cellType: cellType, recognizedText: recognizedText)
            return cell
        }
    }
}


extension SellViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        dismiss(animated: true, completion: nil)

        image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        guard let cgImage = image?.cgImage else { return }
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
            var text = ""
            for observation in observations {
                guard let candidate = observation.topCandidates(1).first else { continue }
                text += "\(candidate.string)\n"
            }
            self?.recognizedText = text.isEmpty ? nil : text
            self?.tableView.reloadData()
        }
        request.recognitionLevel = .accurate
        return request
    }
}

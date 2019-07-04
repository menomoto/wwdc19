import UIKit

class TextViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func set(cellType: SellViewController.CellType, recognizedText: String?) {
        switch cellType {
        case .title:
            if let recognizedText = recognizedText {
                textView.text = recognizedText.components(separatedBy: "\n").first
                textView.textColor = .black
            } else {
                textView.text = "商品タイトル（必須）40文字"
                textView.textColor = UIColor.black.withAlphaComponent(0.54)
            }
        case .description:
            if let recognizedText = recognizedText {
                textView.text = recognizedText
                textView.textColor = .black
            } else {
                textView.text = "商品の説明（任意）1000文字"
                textView.textColor = UIColor.black.withAlphaComponent(0.54)
            }
        default:
            break
        }
    }
}

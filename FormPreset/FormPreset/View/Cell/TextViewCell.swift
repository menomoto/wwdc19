import UIKit

class TextViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.textColor = UIColor.black.withAlphaComponent(0.54)
        }
    }
    
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
            } else {
                textView.text = "商品タイトル（必須）40文字"
            }
        case .description:
            if let recognizedText = recognizedText {
                textView.text = recognizedText
            } else {
                textView.text = "商品タイトル（任意）1000文字"
            }
        default:
            break
        }
    }
}

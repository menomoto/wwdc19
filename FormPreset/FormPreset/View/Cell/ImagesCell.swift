import UIKit

class ImagesCell: UITableViewCell {

    private var itemImage: UIImage?
    private var handler: (() -> Void)?
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            let nib = UINib(nibName: "PhotoCell", bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: "PhotoCell")
        }
    }
    
    func set(image: UIImage?, handler: @escaping () -> Void) {
        self.itemImage = image
        self.handler = handler
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension ImagesCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handler?()
    }
}

extension ImagesCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        if let image = itemImage, indexPath.row == 0 {
            cell.imageView.image = image
        } else {
            cell.imageView.image = UIImage(named: "add_photo")
        }
        return cell
    }
}

extension ImagesCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}

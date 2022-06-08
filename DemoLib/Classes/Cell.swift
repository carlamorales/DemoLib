import UIKit

public class Cell: UITableViewCell {
    public func prepare() {
        prepareCell()
        prepareCellStyles()
        prepareCellConstraints()
    }
    
    private let characterNameLabel = UILabel()
    private let characterSpeciesLabel = UILabel()
    private let characterStatusLabel = UILabel()
    private let characterPictureImageView = UIImageView()
    public let expandAndContractCellButton = UIButton()
    
    private func prepareCell() {
        contentView.addSubview(characterNameLabel)
        contentView.addSubview(characterSpeciesLabel)
        contentView.addSubview(characterStatusLabel)
        contentView.addSubview(characterPictureImageView)
        contentView.addSubview(expandAndContractCellButton)
        
//        let frameworkBundle = Bundle(for: Cell.self)
//        let path = frameworkBundle.path(forResource: "DemoLib", ofType: "bundle")
//        let demoLibBundle = Bundle(url: URL(fileURLWithPath: path!))
//        characterPictureImageView.image = UIImage(named: "puppy", in: demoLibBundle, compatibleWith: nil)
        characterPictureImageView.image = ImageHelper.image(named: "puppy")
    }
    
    public func setCellValues(name: String, species: String, status: String, image: String) {
        if let url = URL(string: image) {
            characterPictureImageView.downloaded(from: url)
        }
        characterNameLabel.text = name
        characterSpeciesLabel.text = species
        characterStatusLabel.text = status
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        characterPictureImageView.image = ImageHelper.image(named: "puppy")
        //characterPictureImageView.image = UIImage(named: "puppy")
    }
    
    private func prepareCellStyles() {
        characterNameLabel.font = UIFont.systemFont(ofSize: 20)
        characterSpeciesLabel.font = UIFont.systemFont(ofSize: 20)
        characterStatusLabel.font = UIFont.systemFont(ofSize: 20)
        characterPictureImageView.contentMode = .scaleAspectFit
        expandAndContractCellButton.backgroundColor = .black
        expandAndContractCellButton.layer.cornerRadius = 5
        expandAndContractCellButton.setTitle("Click", for: .normal)
        expandAndContractCellButton.setTitleColor(.white, for: .normal)
        contentView.clipsToBounds = true
    }
    
    private func prepareCellConstraints() {
        characterPictureImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            characterPictureImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            characterPictureImageView.heightAnchor.constraint(equalToConstant: 80),
            characterPictureImageView.widthAnchor.constraint(equalTo: characterPictureImageView.heightAnchor, multiplier: 16/9),
        ])
            
        characterNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            characterNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            characterNameLabel.leadingAnchor.constraint(equalTo: characterPictureImageView.trailingAnchor),
        ])
            
        characterSpeciesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            characterSpeciesLabel.topAnchor.constraint(equalTo: characterNameLabel.bottomAnchor, constant: 16),
            characterSpeciesLabel.leadingAnchor.constraint(equalTo: characterPictureImageView.trailingAnchor),
        ])
            
        characterStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            characterStatusLabel.topAnchor.constraint(equalTo: characterSpeciesLabel.bottomAnchor, constant: 16),
            characterStatusLabel.leadingAnchor.constraint(equalTo: characterPictureImageView.trailingAnchor),
        ])
            
        expandAndContractCellButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expandAndContractCellButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            expandAndContractCellButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            expandAndContractCellButton.heightAnchor.constraint(equalToConstant: 35),
            expandAndContractCellButton.widthAnchor.constraint(equalToConstant: 75),
        ])
    }
}

let nsCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        if let image = nsCache.object(forKey: url.absoluteString as NSString) {
            self.image = image
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let image = UIImage(data: data) else {
                return
            }
            nsCache.setObject(image, forKey: url.absoluteString as NSString)
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else {
            return
        }
        downloaded(from: url, contentMode: mode)
    }
}

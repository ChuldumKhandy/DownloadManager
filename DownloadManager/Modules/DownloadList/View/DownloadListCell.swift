import UIKit

protocol DownloadListCellDelegate: AnyObject {
  func pauseTapped(cell: DownloadListCell)
  func resumeTapped(cell: DownloadListCell)
}

final class DownloadListCell: UITableViewCell {
    static let identifier = "DownloadListTableViewCell"
    private let fileNameLabel = UILabel()
    private let urlLabel = UILabel()
    private let infoLabel = UILabel()
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let downloadStatusButton = UIButton()
    private var isPaused = true
    
    weak var delegate: DownloadListCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.customizeCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(fileName: String, url: String, info: String, progress: Float) {
        self.fileNameLabel.text = fileName
        self.urlLabel.text = url
        self.infoLabel.text = info
        self.progressView.setProgress(progress, animated: true)
    }
}

private extension DownloadListCell {
    func customizeCell() {
        self.addSubviews()
        self.customizeProgressView()
        self.customizeButton()
        self.setConstraint()
    }
    
    func addSubviews() {
        self.contentView.addSubview(self.fileNameLabel)
        self.contentView.addSubview(self.urlLabel)
        self.contentView.addSubview(self.infoLabel)
        self.contentView.addSubview(self.progressView)
        self.contentView.addSubview(self.downloadStatusButton)
    }
    
    func customizeProgressView() {
        self.progressView.progress = 0
    }
    
    func customizeButton() {
        self.downloadStatusButton.setImage(UIImage(systemName: "playpause"), for: .normal)
        self.downloadStatusButton.addTarget(self, action: #selector(self.didPressPauseResumeButton), for: .touchDown)
    }
    
    @objc private func didPressPauseResumeButton() {
        if self.isPaused {
            self.delegate?.pauseTapped(cell: self)
        } else {
            self.delegate?.resumeTapped(cell: self)
        }
        self.isPaused.toggle()
    }
    
    func setConstraint() {
        self.fileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.urlLabel.translatesAutoresizingMaskIntoConstraints = false
        self.infoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.progressView.translatesAutoresizingMaskIntoConstraints = false
        self.downloadStatusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.fileNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: DownloadListCellConstraints.margin),
            self.fileNameLabel.heightAnchor.constraint(equalToConstant: DownloadListCellConstraints.sizeButton / 2),
            self.fileNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.fileNameLabel.trailingAnchor.constraint(equalTo: self.downloadStatusButton.leadingAnchor, constant: -DownloadListCellConstraints.margin),
            
            self.urlLabel.topAnchor.constraint(equalTo: self.fileNameLabel.bottomAnchor),
            self.urlLabel.heightAnchor.constraint(equalToConstant: DownloadListCellConstraints.sizeButton / 2),
            self.urlLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.urlLabel.trailingAnchor.constraint(equalTo: self.downloadStatusButton.leadingAnchor, constant: -DownloadListCellConstraints.margin),
            
            self.progressView.topAnchor.constraint(equalTo: self.urlLabel.bottomAnchor, constant: DownloadListCellConstraints.margin),
            self.progressView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.progressView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.infoLabel.topAnchor.constraint(equalTo: self.progressView.bottomAnchor),
            self.infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.infoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.downloadStatusButton.topAnchor.constraint(equalTo: self.topAnchor, constant: DownloadListCellConstraints.margin),
            self.downloadStatusButton.heightAnchor.constraint(equalToConstant: DownloadListCellConstraints.sizeButton),
            self.downloadStatusButton.widthAnchor.constraint(equalToConstant: DownloadListCellConstraints.sizeButton),
            self.downloadStatusButton.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}

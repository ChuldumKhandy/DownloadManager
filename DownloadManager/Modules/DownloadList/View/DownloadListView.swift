import UIKit

protocol IDownloadListView: UIView {
    var getUrlHandler: ((String?) -> Void)? { get set }
    var didPressPauseButtonAtHandler: ((Int) -> Void)? { get set }
    var didPressResumeButtonAtHandler: ((Int) -> Void)? { get set }
    
    func getData(data: [FileModel])
}

final class DownloadListView: UIView {
    private let urlTextField = UITextField()
    private let downloadButton = UIButton()
    private let tableOfUploadedFiles = DownloadListTableView()

    var getUrlHandler: ((String?) -> Void)?
    var didPressPauseButtonAtHandler: ((Int) -> Void)?
    var didPressResumeButtonAtHandler: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customizeView()
        self.tableOfUploadedFiles.didPressPauseButtonAtHandler = { [weak self] index in
            self?.didPressPauseButtonAtHandler?(index)
        }
        self.tableOfUploadedFiles.didPressResumeButtonAtHandler = { [weak self] index in
            self?.didPressResumeButtonAtHandler?(index)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.customizeView()
    }
}

extension DownloadListView: IDownloadListView {
    func getData(data: [FileModel]) {
        self.tableOfUploadedFiles.rowCountHandler = { [weak self] in
            return data.count
        }
        self.tableOfUploadedFiles.dataHandler = { [weak self] index in
            return data[index]
        }
        self.tableOfUploadedFiles.reloadData()
    }
}

private extension DownloadListView {
    func customizeView() {
        self.backgroundColor = .white
        self.addSubviews()
        self.customizeTextField()
        self.customizeButton()
        self.setConstraints()
    }
    
    func addSubviews() {
        self.addSubview(self.urlTextField)
        self.addSubview(self.downloadButton)
        self.addSubview(self.tableOfUploadedFiles)
    }
    
    func customizeTextField() {
        self.urlTextField.placeholder = "Введите URL картинки"
        self.urlTextField.backgroundColor = .systemGray6
        self.urlTextField.borderStyle = .roundedRect
        self.urlTextField.layer.cornerRadius = DownloadListViewConstraints.radius
        self.urlTextField.layer.masksToBounds = true
    }
    
    func customizeButton() {
        self.downloadButton.setTitle("Download", for: .normal)
        self.downloadButton.setTitleColor(.black, for: .normal)
        self.downloadButton.backgroundColor = .systemGray6
        self.downloadButton.titleLabel?.font = .italicSystemFont(ofSize: 16)
        self.downloadButton.layer.cornerRadius = SettingsConstraints.radius
        self.downloadButton.layer.masksToBounds = true
        self.downloadButton.addTarget(self, action: #selector(self.touchedDown), for: .touchDown)
    }
    
    @objc private func touchedDown() {
        self.getUrlHandler?(self.urlTextField.text)
    }
    
    func setConstraints() {
        self.urlTextField.translatesAutoresizingMaskIntoConstraints = false
        self.downloadButton.translatesAutoresizingMaskIntoConstraints = false
        self.tableOfUploadedFiles.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.urlTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: DownloadListViewConstraints.top),
            self.urlTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: DownloadListViewConstraints.left),
            self.urlTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -DownloadListViewConstraints.left),
            
            self.downloadButton.topAnchor.constraint(equalTo: self.urlTextField.bottomAnchor, constant: DownloadListViewConstraints.margin),
            self.downloadButton.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: DownloadListViewConstraints.left),
            self.downloadButton.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -DownloadListViewConstraints.left),
            
            self.tableOfUploadedFiles.topAnchor.constraint(equalTo: self.downloadButton.bottomAnchor, constant: DownloadListViewConstraints.margin),
            self.tableOfUploadedFiles.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.tableOfUploadedFiles.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: DownloadListViewConstraints.left),
            self.tableOfUploadedFiles.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -DownloadListViewConstraints.left)
        ])
    }
}

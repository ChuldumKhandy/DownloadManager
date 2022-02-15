import UIKit

protocol ISettingsView: UIView {
    var saveSettings: ((_ maxSegmentSize: String?,
                        _ numberOfSegments: String?,
                        _ numberOfFiles: String?,
                        _ numberOfAttemptsReconnect: String?) -> Void)? { get set }
}

final class SettingsView: UIView {
    private let maxSegmentSizeLabel = UILabel()
    private let maxSegmentSizeTextField = UITextField()
    private let maxNumberOfSegmentsLabel = UILabel()
    private let maxNumberOfSegmentsTextField = UITextField()
    private let maxNumberOfFilesLabel = UILabel()
    private let maxNumberOfFilesTextField = UITextField()
    private let numberOfAttemptsReconnectLabel = UILabel()
    private let numberOfAttemptsReconnectTextField = UITextField()
    private let saveButton = UIButton()
    private let stackView = UIStackView()
    
    var saveSettings: ((_ maxSegmentSize: String?,
                        _ numberOfSegments: String?,
                        _ numberOfFiles: String?,
                        _ numberOfAttemptsReconnect: String?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customizeView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.customizeView()
    }
}

extension SettingsView: ISettingsView {
}

private extension SettingsView {
    func customizeView() {
        self.addSubview(self.stackView)
        self.addSubview(self.saveButton)
        self.customizeStackView()
        self.customizeLabels()
        self.customizeTextFields()
        self.customizeButton()
        self.setConstraints()
    }
    
    func customizeStackView() {
        self.stackView.axis = .vertical
        self.stackView.distribution = .equalSpacing
        self.stackView.alignment = .fill
        self.stackView.spacing = SettingsConstraints.margin
        self.stackView.addArrangedSubview(self.maxSegmentSizeLabel)
        self.stackView.addArrangedSubview(self.maxSegmentSizeTextField)
        self.stackView.addArrangedSubview(self.maxNumberOfSegmentsLabel)
        self.stackView.addArrangedSubview(self.maxNumberOfSegmentsTextField)
        self.stackView.addArrangedSubview(self.maxNumberOfFilesLabel)
        self.stackView.addArrangedSubview(self.maxNumberOfFilesTextField)
        self.stackView.addArrangedSubview(self.numberOfAttemptsReconnectLabel)
        self.stackView.addArrangedSubview(self.numberOfAttemptsReconnectTextField)
    }
    
    func customizeLabels() {
        UILabel.appearance().numberOfLines = 0
        UILabel.appearance().lineBreakMode = .byWordWrapping
        self.maxSegmentSizeLabel.text = "Размер сегмента:"
        self.maxNumberOfSegmentsLabel.text = "Количество одновременно скачиваемых сегментов:"
        self.maxNumberOfFilesLabel.text = "Число одновременно скачиваемых файлов:"
        self.numberOfAttemptsReconnectLabel.text = "Количество попыток восстановить соединение:"
    }
    
    func customizeTextFields() {
        UITextField.appearance().backgroundColor = .systemGray6
        UITextField.appearance().borderStyle = .roundedRect
        UITextField.appearance().layer.cornerRadius = SettingsConstraints.radius
        UITextField.appearance().layer.masksToBounds = true
        self.maxSegmentSizeTextField.placeholder = "Размер в байтах"
        self.maxNumberOfSegmentsTextField.placeholder = "Необязательно"
        self.maxNumberOfFilesTextField.placeholder = "Необязательно"
        self.numberOfAttemptsReconnectTextField.placeholder = "Необязательно"
    }
      
    func customizeButton() {
        self.saveButton.setTitle("Save", for: .normal)
        self.saveButton.setTitleColor(.black, for: .normal)
        self.saveButton.backgroundColor = .systemGray6
        self.saveButton.layer.cornerRadius = SettingsConstraints.radius
        self.saveButton.layer.masksToBounds = true
        self.saveButton.titleLabel?.font = .italicSystemFont(ofSize: 16)
        self.saveButton.addTarget(self, action: #selector(self.touchedDown), for: .touchDown)
    }
    
    @objc private func touchedDown() {
        self.saveSettings?(self.maxSegmentSizeTextField.text,
                           self.maxNumberOfSegmentsTextField.text,
                           self.maxNumberOfFilesTextField.text,
                           self.numberOfAttemptsReconnectTextField.text)
    }
    
    func setConstraints() {
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: SettingsConstraints.top),
            self.stackView.bottomAnchor.constraint(equalTo: self.centerYAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: SettingsConstraints.left),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -SettingsConstraints.left),
            
            self.saveButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: SettingsConstraints.left),
            self.saveButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -SettingsConstraints.left),
            self.saveButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -SettingsConstraints.margin),
        ])
    }
}


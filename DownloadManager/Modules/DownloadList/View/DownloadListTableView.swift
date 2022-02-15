import UIKit

final class DownloadListTableView: UITableView {
    var dataHandler: ((Int) -> FileModel?)?
    var rowCountHandler: (() -> Int?)?
    var didPressPauseButtonAtHandler: ((Int) -> Void)?
    var didPressResumeButtonAtHandler: ((Int) -> Void)?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.customizeTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DownloadListTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowCountHandler?() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: DownloadListCell.identifier, for: indexPath) as? DownloadListCell,
           let data = self.dataHandler?(indexPath.row) {
            cell.delegate = self
            cell.setData(fileName: data.name, url: data.url.absoluteString, info: data.progressString, progress: data.progress)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension DownloadListTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DownloadListCellConstraints.height
    }
}

extension DownloadListTableView: DownloadListCellDelegate {
    func pauseTapped(cell: DownloadListCell) {
        if let index = self.indexPath(for: cell)?.row {
            self.didPressPauseButtonAtHandler?(index)
        }
    }
    
    func resumeTapped(cell: DownloadListCell) {
        if let index = self.indexPath(for: cell)?.row {
            self.didPressResumeButtonAtHandler?(index)
        }
    }
}

private extension DownloadListTableView {
    func customizeTableView() {
        self.register(DownloadListCell.self, forCellReuseIdentifier: DownloadListCell.identifier)
        self.dataSource = self
        self.delegate = self
        self.setConstraint()
    }
    
    func setConstraint() {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: self.topAnchor),
            self.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}

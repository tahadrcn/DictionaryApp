import UIKit

class RecentSearchCell: UITableViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupUI()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setupUI() {
            textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            textLabel?.textColor = .darkGray

            backgroundColor = .white
            layer.cornerRadius = 8
            layer.masksToBounds = true
            layer.borderColor = UIColor.lightGray.cgColor
            layer.borderWidth = 1
            selectionStyle = .none
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16))
        }
    
}

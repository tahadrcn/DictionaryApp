import UIKit

protocol HomeViewProtocol: AnyObject {
    func displayRecentSearches(_ searches: [String])
}

class HomeViewController: UIViewController, HomeViewProtocol {
    var presenter: HomePresenterProtocol?
    private var recentSearches: [String] = []
    private let maxRecentSearches = 5

    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Aramak için kelime girin"
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 8
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOpacity = 0.1
        textField.layer.shadowOffset = CGSize(width: 0, height: 2)
        textField.layer.shadowRadius = 4
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ara", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    let recentSearchesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
        recentSearchesTableView.dataSource = self
        recentSearchesTableView.delegate = self

        recentSearchesTableView.register(RecentSearchCell.self, forCellReuseIdentifier: "RecentSearchCell")
    }

    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        view.addSubview(recentSearchesTableView)

        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),

            searchButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 100),
            searchButton.heightAnchor.constraint(equalToConstant: 40),

            recentSearchesTableView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 20),
            recentSearchesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recentSearchesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recentSearchesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc func searchButtonTapped(_ sender: UIButton) {
        if let searchText = searchTextField.text, !searchText.isEmpty {
            presenter?.searchButtonTapped(with: searchText)
            updateRecentSearches(with: searchText)
        }
    }

    private func updateRecentSearches(with searchText: String) {
        recentSearches.insert(searchText, at: 0)
        
        if recentSearches.count > maxRecentSearches {
            recentSearches.removeLast()
        }
        
        recentSearchesTableView.reloadData()
    }

    func displayRecentSearches(_ searches: [String]) {
        DispatchQueue.main.async { [weak self] in
            self?.recentSearches = searches
            self?.recentSearchesTableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchCell", for: indexPath) as! RecentSearchCell
        cell.textLabel?.text = recentSearches[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRecentSearch(recentSearches[indexPath.row])
    }
}

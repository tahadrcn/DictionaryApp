import UIKit
import AVFoundation

protocol DetailViewProtocol: AnyObject {
    func displayWordDetails(_ details: WordDetails)
    func displaySynonyms(_ synonyms: [String])
    func displayError(_ error: String)
}

class DetailViewController: UIViewController, DetailViewProtocol {
    var presenter: DetailPresenterProtocol?
    var audioPlayer: AVPlayer?
    var wordDetails: WordDetails?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let wordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let phoneticsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefinitionCell")
        return tableView
    }()
    
    private let synonymsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let audioButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sesini Dinle", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playAudio), for: .touchUpInside)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var expandedSections = Set<Int>()
    private var partOfSpeechSections: [(partOfSpeech: String, definitions: [Definition])] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(wordLabel)
        contentView.addSubview(phoneticsLabel)
        contentView.addSubview(tableView)
        contentView.addSubview(synonymsLabel)
        contentView.addSubview(audioButton)
        contentView.addSubview(errorLabel)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            wordLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            wordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            wordLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            phoneticsLabel.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 10),
            phoneticsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            phoneticsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: phoneticsLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            tableView.heightAnchor.constraint(equalToConstant: 300),
            
            synonymsLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            synonymsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            synonymsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            audioButton.topAnchor.constraint(equalTo: synonymsLabel.bottomAnchor, constant: 20),
            audioButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            audioButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            errorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func displayWordDetails(_ details: WordDetails) {
        wordLabel.text = details.word.uppercased()
        phoneticsLabel.text = details.phonetic != nil ? "Phonetic: \(details.phonetic)" : ""
        
        partOfSpeechSections = details.meanings.map { ($0.partOfSpeech, $0.definitions) }
        
        if let synonyms = details.synonyms, !synonyms.isEmpty {
            synonymsLabel.isHidden = false
            synonymsLabel.text = "Synonyms: \(synonyms.joined(separator: ", "))"
        } else {
            synonymsLabel.isHidden = true
        }
        
        tableView.reloadData()
        
        audioButton.isHidden = details.phonetic == nil
        errorLabel.isHidden = true
    }
    
    func displaySynonyms(_ synonyms: [String]) {
        synonymsLabel.isHidden = synonyms.isEmpty
        synonymsLabel.text = "Synonyms: \(synonyms.joined(separator: ", "))"
    }
    
    func displayError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func playAudio() {
        
        guard let audioUrlString = wordDetails?.audio, let url = URL(string: audioUrlString) else { return }
               print(url)
               audioPlayer = AVPlayer(url: url)
               audioPlayer?.play()
    }
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return partOfSpeechSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expandedSections.contains(section) ? partOfSpeechSections[section].definitions.count : 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return partOfSpeechSections[section].partOfSpeech.capitalized
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefinitionCell", for: indexPath)
        let definition = partOfSpeechSections[indexPath.section].definitions[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = """
        Definition: \(definition.definition)
        Example: \(definition.example ?? "No example available")
        """
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UITableViewHeaderFooterView()
        header.textLabel?.text = partOfSpeechSections[section].partOfSpeech.capitalized
        header.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleHeaderTap(_:))))
        header.tag = section
        return header
    }
    
    @objc private func handleHeaderTap(_ sender: UITapGestureRecognizer) {
        guard let section = sender.view?.tag else { return }
        if expandedSections.contains(section) {
            expandedSections.remove(section)
        } else {
            expandedSections.insert(section)
        }
        tableView.reloadSections([section], with: .automatic)
    }
}

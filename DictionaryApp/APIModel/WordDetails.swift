struct WordDetails: Codable {
    let word: String
    let phonetic: String?
    let meanings: [Meaning]
    let synonyms: [String]?
    let noun: String?
    let adjective: String?
    var phonetics: [Phonetic]?

    var audio: String? {
        return phonetics?.first(where: { $0.audio != nil })?.audio
    }

    private enum CodingKeys: String, CodingKey {
        case word, phonetic, meanings, synonyms, noun, adjective, phonetics
    }
}

struct Meaning: Codable {
    let partOfSpeech: String
    let definitions: [Definition]
}

struct Definition: Codable {
    let definition: String
    let example: String?
    let synonyms: [String]?
}

struct Phonetic: Codable {
    let text: String
    let audio: String?
    
    private enum CodingKeys: String, CodingKey {
        case text, audio
    }
}

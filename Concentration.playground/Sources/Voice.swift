import AVFoundation

public enum LanguageCode: String {
    case chinese = "zh-CN"
    case english = "en-US"
    case swedish = "sv-SE"
}

public class Voice {
    
    private let voice: AVSpeechSynthesisVoice
    private let synthesizer: AVSpeechSynthesizer
    
    public static func availableLanguageCodes() -> [String] {
        return AVSpeechSynthesisVoice.speechVoices().map { $0.language }
    }
    
    public init?(language: String) {
        guard let voice = AVSpeechSynthesisVoice(language: language) else {
            return nil
        }
        self.voice = voice
        self.synthesizer = AVSpeechSynthesizer()
    }
    
    public convenience init?(language: LanguageCode) {
        self.init(language: language.rawValue)
    }
    
    public func speak(_ textToBeSpoken: String) {
        let utterance = AVSpeechUtterance(string: textToBeSpoken)
        utterance.voice = voice
        synthesizer.speak(utterance)
    }
}

//
//  ContentView.swift
//  AAC
//
//  Created by Steven Huang on 2/10/24.
//

import SwiftUI
import Speech

struct Voice: Identifiable, Hashable {
    var id = UUID()
    var voice: AVSpeechSynthesisVoice
    
    init(_ voice: AVSpeechSynthesisVoice) {
        self.voice = voice
    }
}

struct ContentView: View {
    private let initialReleaseDate = Date(timeIntervalSinceNow: -3000000)
    private let installedReleaseDate = Date(timeIntervalSinceNow: -2000000)
    private let latestReleaseDate = Date(timeIntervalSinceNow: -1000000)
    private let userName = "Lins"
    private let iconSize = 48.0
    @State private var currentTheme = themes[0]
    private let synthesizer = AVSpeechSynthesizer()
    private let voices: [Voice] = AVSpeechSynthesisVoice.speechVoices().filter({ $0.language.hasPrefix("en") }).map({ Voice($0) })
    @State private var currentVoice = Voice(AVSpeechSynthesisVoice.speechVoices().first!)
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to *Boses*, \(userName)")
                    .font(.title)
                Spacer()
                Text("Release (installed):")
                Text(installedReleaseDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.title2)
                Spacer()
                Text("Release (latest):")
                Text(latestReleaseDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.title2)
                    .underline()
                Spacer()
                Text("Release (initial):")
                Text(initialReleaseDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.title2)
                Spacer()
                HStack {
                    MyButton(imageName: "checkmark")
                        .classicBordered(true)
                    MyButton(imageName: "xmark")
                        .classicBordered()
                }
                .frame(maxWidth: .infinity)
                Spacer()
                Rectangle()
                    .frame(height: 1)
                HStack {
                    Button {
                    } label: {
                        VStack {
                            Image(systemName: "arrow.forward")
                                .font(.system(size: iconSize, weight: .bold))
                            Text("In")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                    }
                    Spacer()
                    MyButton("Process") {
                        let utterance = AVSpeechUtterance(string: "The quick brown fox jumped over the lazy dog.")
                        utterance.rate = 0.5
                        utterance.pitchMultiplier = 0.8
                        utterance.postUtteranceDelay = 0.2
                        utterance.volume = 0.8
                        utterance.voice = currentVoice.voice
                        
                        synthesizer.speak(utterance)
                    }
                    .classicBordered()
                    Spacer()
                    Button {
                    } label: {
                        VStack {
                            Text("Out")
                                .font(.title)
                                .fontWeight(.bold)
                            Image(systemName: "arrow.forward")
                                .font(.system(size: iconSize, weight: .bold))
                        }
                    }
                }
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu("Options") {
                        Menu("Themes") {
                            Picker("Themes", selection: $currentTheme) {
                                ForEach(themes) { theme in
                                    Text(theme.name)
                                        .tag(theme)
                                }
                            }
                            .tint(currentTheme.foregroundColor)
                            .labelsHidden() // oddly, this left-aligns the selected value
                        }
                        Menu("Voices") {
                            Picker("Voices", selection: $currentVoice) {
                                ForEach(voices) { voice in
                                    Text(voice.voice.name)
                                        .tag(voice)
                                }
                            }
                            .tint(currentTheme.foregroundColor)
                            .labelsHidden() // oddly, this left-aligns the selected value
                        }
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Home")
                        .font(.title2)
                        .bold()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "chevron.forward")
                            .imageScale(.large)
                    }
                }
            }
            .foregroundColor(currentTheme.foregroundColor)
            .background(currentTheme.backgroundColor)
        }
    }
}

struct ClassicBordered: ViewModifier {
    private let thick = 4.0
    private let gap = 5.0
    private let thin = 2.0
    
    var isDefault = false
    func body(content: Content) -> some View {
        if isDefault {
            return AnyView(content
                .background(
                    ZStack {
                        Capsule(style: .continuous)
                            .stroke(.foreground, lineWidth: thick)
                        Capsule(style: .continuous)
                            .inset(by: gap)
                            .stroke(.foreground, lineWidth: thin)
                    }
                )
            )
        }
        else {
            return AnyView(content
                .background(
                    Capsule(style: .continuous)
                        .stroke(.primary, lineWidth: thin)
                )
            )
        }
    }
}

extension View {
    func classicBordered(_ isDefault: Bool = false) -> some View {
        modifier(ClassicBordered(isDefault: isDefault))
    }
}

struct MyButton: View {
    private var stringKey: LocalizedStringKey? = nil
    private var imageName: String? = nil
    private var action: (() -> Void)? = nil
    
    init(_ stringKey: LocalizedStringKey? = nil, imageName: String? = nil, action:(() -> Void)? = nil) {
        self.imageName = imageName
        self.stringKey = stringKey
        self.action = action
    }
    
    var body: some View {
        Button {
            if let action {
                action()
            }
        } label: {
            Group {
                if let stringKey {
                    Text(stringKey)
                        .font(.title)
                        .fontWeight(.bold)
                }
                if let imageName {
                    Image(systemName: imageName)
                        .fontWeight(.bold)
                        .imageScale(.large)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(24)
        }
    }
}

#Preview {
    ContentView()
}

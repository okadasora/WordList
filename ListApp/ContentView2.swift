//
//  ContentView2.swift
//  ListApp
//
//  Created by x22021xx on 2024/11/17.
//

import SwiftUI
import AVFAudio

struct ContentView2: View {
    @Binding var cards: [String: String] // カードのディクショナリをバインディングに変更
    @State var currentCard: (key: String, value: String)? = nil
    @State var isJapanese = true
    @State var showText = true // テキストを表示するかどうかの状態
    @State private var isSpeaking = false // 音声が読み上げられているかどうかを示す状態変数
    let speechSynthesizer = AVSpeechSynthesizer()
    var speechDelegate: SpeechSynthesizerDelegateHelper

    init(cards: Binding<[String: String]>) {
        self._cards = cards
        self.speechDelegate = SpeechSynthesizerDelegateHelper(isSpeaking: .constant(false))
        self.speechSynthesizer.delegate = self.speechDelegate
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(red: 0.56, green: 0.96, blue: 0.56)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    ZStack {
                        Image("cards")
                            .resizable()
                            .frame(width: 430.0, height: 280.0)
                            .shadow(radius: 3)
                            .offset(x: isJapanese ? -15 : 5)
                            .rotation3DEffect(.degrees(isJapanese ? 0 : 180), axis: (x: 0, y: 1, z: 0))
                            .animation(.spring(), value: isJapanese)
                            .onTapGesture {
                                self.isJapanese.toggle()
                                self.showText = false // 裏返す際にテキストを非表示にする
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    self.showText = true // 裏返してから0.1秒後にテキストを表示
                                }
                            }
                        
                        if let card = currentCard {
                            VStack {
                                Text(isJapanese ? card.key : card.value)
                                    .font(.largeTitle)
                                    .frame(width: geometry.size.width * 0.55, height: geometry.size.height * 0.9)
                                    .offset(x: isJapanese ? 15 : -35, y: 20)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.5)
                                    .opacity(showText ? 1.0 : 0.0) // テキストを表示するかどうかを制御する
                                    .animation(.spring(), value: showText)
                                Image(systemName: "speaker.wave.3.fill")
                                    .resizable()
                                    .foregroundColor(isSpeaking ? .blue : .black) // 音声が読み上げられている間は青色にする
                                    .frame(width: 30, height: 25)
                                    .offset(x: isJapanese ? 105 : 65, y: -290)
                                    .opacity(showText ? 1.0 : 0.0) //テキストと同様に不透明度を制御
                                    .animation(.spring(), value: showText) //アニメーションを適用
                                    .onTapGesture {
                                        let text = isJapanese ? card.key : card.value
                                        readText(text: text)
                                    }
                                    .animation(.spring(), value: isSpeaking)
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.3)
                        } else {
                            Text("")
                                .font(.largeTitle)
                        }
                    }
                    .frame(height: geometry.size.height * 0.6) // カード画像の高さを調整
                    
                    VStack {
                        Button(action: {
                            self.isJapanese.toggle()
                            self.showText = false // 裏返す際にテキストを非表示にする
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                self.showText = true // 裏返してから0.1秒後にテキストを表示
                            }
                        }) {
                            Image(systemName: "arrow.2.circlepath")
                            Text("裏返す")
                                .font(.system(size: 27))
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(red: 0.86, green: 0.35, blue: 0.03))
                        .cornerRadius(10)
                        
                        HStack {
                            Group {
                                Button(action: {
                                    if !self.cards.isEmpty {
                                        self.isJapanese = true
                                        self.showText = false // 次のカードに進む際にテキストを非表示にする
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            self.currentCard = self.cards.randomElement()
                                            self.showText = true // 次のカードを表示する前に0.1秒待ってからテキストを表示
                                        }
                                    }
                                }) {
                                    Image(systemName: "forward.fill")
                                    Text("ランダム")
                                        .font(.system(size: 25))
                                }
                                Button(action: {
                                    if !self.cards.isEmpty {
                                        self.isJapanese = true
                                        self.showText = false // 次のカードに進む際にテキストを非表示にする
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            // 現在のカードが設定されているか確認
                                            if let currentCard = self.currentCard {
                                                //キーのリストを取得し、現在のカードのキーの次のキーを探す
                                                let keys = Array(self.cards.keys)
                                                if let currentIndex = keys.firstIndex(of: currentCard.key), currentIndex + 1 < keys.count {
                                                    let nextIndex = currentIndex + 1
                                                    let nextKey = keys[nextIndex]
                                                    self.currentCard = (key: nextKey, value: self.cards[nextKey]!)
                                                } else {
                                                    //最後のカードの場合、最初のカードに戻る
                                                    let firstKey = keys.first!
                                                    self.currentCard = (key: firstKey, value: self.cards[firstKey]!)
                                                }
                                            } else {
                                                //currentCardがnilの場合、最初のカードを表示
                                                if let firstCard = self.cards.first {
                                                    self.currentCard = firstCard
                                                }
                                            }
                                            self.showText = true // 次のカードを表示する前に0.1秒待ってからテキストを表示
                                        }
                                    }
                                }) {
                                    Image(systemName: "forward.fill")
                                    Text("次へ")
                                        .font(.system(size: 25))
                                }.padding(EdgeInsets(
                                    top: 0,        // 上の余白
                                    leading: 15,    // 左の余白
                                    bottom: 0,     // 下の余白
                                    trailing: 15    // 右の余白
                                ))
                            }.padding()
                            .foregroundColor(.white)
                            .background(Color(red: 0.12, green: 0.15, blue: 0.73))
                            .cornerRadius(10)
                        }
                    }
                    .frame(height: geometry.size.height * 0.3) // ボタンの高さを調整
                }
                .navigationBarItems(trailing:
                    NavigationLink(destination: AddCard(cards: $cards)) {
                        Text("カードの追加")
                    }
                )
            }
            .onAppear {
                if let firstCard = cards.first {
                    self.currentCard = firstCard
                    self.showText = true // 初期表示時にテキストを表示
                } else {
                    self.currentCard = nil
                    self.showText = false
                }
            }
            .onChange(of: cards) { newCards in
                if let firstCard = newCards.first {
                    self.currentCard = firstCard
                    self.showText = true
                } else {
                    self.currentCard = nil
                    self.showText = false
                }
            }
        }
    }
    
    // 言語判別関数
    func detectLanguage(for text: String) -> String {
        // Define CharacterSets for Japanese text ranges
        let hiraganaCharset = CharacterSet(charactersIn: UnicodeScalar(0x3040)!...UnicodeScalar(0x309F)!)
        let katakanaCharset = CharacterSet(charactersIn: UnicodeScalar(0x30A0)!...UnicodeScalar(0x30FF)!)
        let kanjiCharset = CharacterSet(charactersIn: UnicodeScalar(0x4E00)!...UnicodeScalar(0x9FFF)!)

        let hasHiragana = text.rangeOfCharacter(from: hiraganaCharset) != nil
        let hasKatakana = text.rangeOfCharacter(from: katakanaCharset) != nil
        let hasKanji = text.rangeOfCharacter(from: kanjiCharset) != nil

        if hasHiragana || hasKatakana || hasKanji {
            return "ja-JP"
        } else {
            return "en-US"
        }
    }
    
    // 音声読み上げ関数
    func readText(text: String) {
        let language = detectLanguage(for: text)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        speechSynthesizer.speak(utterance)
        
        speechDelegate.isSpeaking = true
        speechSynthesizer.delegate = speechDelegate
    }
}

#Preview {
    ContentView2(cards: .constant([:])) // ダミーデータを渡す
}

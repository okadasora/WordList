//
//  ContentView.swift
//  ListApp
//
//  Created by x22021xx on 2024/04/21.
//

import SwiftUI
import AVFoundation

// リスト情報を保持する構造体
struct ListInfo: Identifiable {
    var id = UUID()
    var name: String
    var cards: [String: String]
    var color: Color
}

struct StickyNoteView: View {
    var listInfo: ListInfo
    let userDefaults = UserDefaults.standard
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    let w = geometry.size.width
                    let h = geometry.size.height
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: h))
                    path.addLine(to: CGPoint(x: w, y: h))
                    path.addLine(to: CGPoint(x: w, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: 0))
                }
                .fill(listInfo.color)
                Path { path in
                    let w = geometry.size.width
                    let h =  geometry.size.height
                    let m = min(w , h);
                    path.move(to: CGPoint(x: 0, y: h))
                    path.addLine(to: CGPoint(x: m-20, y: h))
                    path.addLine(to: CGPoint(x: m-20, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: 0))
                }
                .fill(Color.black).opacity(0.4)
            }
        }
    }
}

struct ContentView: View {
    @State var lists = [ListInfo]() // リスト情報の配列
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(lists) { listInfo in
                        NavigationLink(destination: ContentView2(cards: $lists[lists.firstIndex(where: { $0.id == listInfo.id })!].cards)) {
                            HStack {
                                Circle()
                                    .fill(listInfo.color == Color.white ? .black : .white)
                                    .frame(width: 25, height: 25) // 丸のサイズを設定
                                    .padding(.leading, -10) // 必要に応じて負の値を調整して Circle を左に移動
                                Text(listInfo.name) // リスト名を表示
                                    .foregroundColor(listInfo.color == Color.black ? .white : .primary)
                                    .padding(5)
                                    .font(.system(size: 25))
                            }
                        }
                        .listRowBackground(StickyNoteView(listInfo: listInfo)) // リストの色を設定
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                deleteList(id: listInfo.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .navigationBarItems(trailing:
                    NavigationLink(destination: AddList(lists: $lists)) {
                        Text("リストの追加")
                    }
                )
            }
            .navigationTitle("Card Lists")
        }
    }
    
    private func deleteList(id: UUID) {
        lists.removeAll { $0.id == id }
    }
}

class SpeechSynthesizerDelegateHelper: NSObject, AVSpeechSynthesizerDelegate {
    @Binding var isSpeaking: Bool

    init(isSpeaking: Binding<Bool>) {
        self._isSpeaking = isSpeaking
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        isSpeaking = true
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

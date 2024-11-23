//
//  AddCard.swift
//  ListApp
//
//  Created by x22021xx on 2024/11/17.
//

import SwiftUI

struct AddCard: View {
    @State private var frontName: String = ""
    @State private var backName: String = ""
    @Binding var cards: [String: String] // ContentView2から渡されるカードのディクショナリ
    
    @Environment(\.presentationMode) var presentationMode // プレゼンテーションモード
    @State private var showAlert = false // アラートの表示を制御する状態変数
    @State private var showList = false //リストの表示を制御する状態変数
    @State private var emptyAlert_f = false
    @State private var emptyAlert_b = false

    var body: some View {
        VStack {
            VStack {
                TextField("カード名(表)", text: $frontName)
                    .font(.system(size: 22))
                    .padding(.all)
                    .background(Color.white) // 背景色を追加
                    .cornerRadius(5.0) // 角を丸める
                    .overlay(
                        RoundedRectangle(cornerRadius: 5.0)
                            .stroke(Color.gray, lineWidth: 3.0) // 枠線を追加
                    )
                    .padding()
                TextField("カード名(裏)", text: $backName)
                    .font(.system(size: 22))
                    .padding(.all)
                    .background(Color.white) // 背景色を追加
                    .cornerRadius(5.0) // 角を丸める
                    .overlay(
                        RoundedRectangle(cornerRadius: 5.0)
                            .stroke(Color.gray, lineWidth: 3.0) // 枠線を追加
                    )
                    .padding(.horizontal)
            }
            
            Button(action: {
                if frontName.isEmpty {
                    self.emptyAlert_f = true
                } else if backName.isEmpty {
                    self.emptyAlert_b = true
                } else {
                    self.showAlert = true // アラートを表示
                }
            }) {
                Text("カードを追加")
                    .font(.system(size: 20))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.all)
            .alert("Error", isPresented: $emptyAlert_f, presenting: $emptyAlert_b) {_ in
            } message: {_ in
                Text("表と裏のカード名を入力してください")
            }
            .alert("Error", isPresented: $emptyAlert_f) {
            } message: {
                Text("表のカード名を入力してください")
            }
            .alert("Error", isPresented: $emptyAlert_b) {
            } message: {
                Text("裏のカード名を入力してください")
            }
            .alert("Card", isPresented: $showAlert) {
                Button("いいえ") {}
                Button("はい") {
                    self.cards[self.frontName] = self.backName // カードを追加
                    
                    self.frontName = "" // フィールドをクリア
                    self.backName = "" // フィールドをクリア
                    self.presentationMode.wrappedValue.dismiss() // 前の画面に戻る
                }
            } message: {
                Text("'\(frontName)'・'\(backName)' を追加しますか？")
            }
            .padding()
            
            Button(action: { showList.toggle() }) {
                VStack {
                    if showList == false {
                        Text("カードリスト履歴")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.teal)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    } else if showList == true {
                        Text("履歴を閉じる")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        List {
                            ForEach(cards.sorted(by: <), id: \.key) { key, value in
                                HStack {
                                    Text(key) // カード名を表示
                                        .font(.headline)
                                        .font(.system(size: 20))
                                    Spacer()
                                    Divider()
                                    Spacer()
                                    Text(value)
                                        .font(.headline)
                                        .foregroundColor(.red)
                                        .font(.system(size: 20))
                                }
                            }
                            .onDelete(perform: deleteCard)
                        }
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
        .padding() // 全体の余白を追加
        Spacer()
    }

    private func deleteCard(at offsets: IndexSet) {
        for index in offsets {
            let key = cards.keys.sorted()[index]
            cards.removeValue(forKey: key)
        }
    }
}

#Preview {
    AddCard(cards: .constant([:])) // ダミーデータを渡す
}

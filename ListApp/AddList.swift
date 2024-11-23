//
//  AddList.swift
//  ListApp
//
//  Created by x22021xx on 2024/11/17.
//

import SwiftUI

struct AddList: View {
    @State private var listName: String = ""
    @State private var selectedColor: Color = .red // 初期色を黒に設定
    @Binding var lists: [ListInfo] // ContentViewから渡されるリスト情報の配列
    @Environment(\.presentationMode) var presentationMode // プレゼンテーションモード
    @State private var showAlert = false // アラートの表示を制御する状態変数
    @State private var emptyAlert = false // アラートの表示を制御する状態変数
    
    let colors: [Color] = [.red, .green, .blue, .yellow, .orange, .pink, .purple, .brown] // 限定する色の配列
    
    var body: some View {
        VStack {
            TextField("リスト名", text: $listName) // リスト名を入力
                .padding(.all)
                .background(Color.white) // 背景色を追加
                .cornerRadius(5.0) // 角を丸める
                .font(.system(size: 22))
                .overlay(
                    RoundedRectangle(cornerRadius: 5.0)
                        .stroke(Color.gray, lineWidth: 3.0) // 枠線を追加
                )
                .padding()
            
            // カスタムカラー選択メニュー
            Text("リストの色:")
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack {
                // 上の行
                HStack {
                    ForEach(0..<4) { index in
                            if index < colors.count {
                                Circle()
                                    .fill(colors[index])
                                    .frame(width: 60, height: 60)
                                    .onTapGesture {
                                        self.selectedColor = colors[index]
                                    }
                                    .overlay(
                                        Circle()
                                            .stroke(Color.black, lineWidth: self.selectedColor == colors[index] ? 5 : 3)
                                    )
                                    .padding(3)
                                }
                            }
                        }
                        .padding(.bottom, 12) // 行間の余白
                            
                        // 下の行
                        HStack {
                            ForEach(4..<8) { index in
                                if index < colors.count {
                                    Circle()
                                        .fill(colors[index])
                                        .frame(width: 60, height: 60)
                                        .onTapGesture {
                                            self.selectedColor = colors[index]
                                        }
                                        .overlay(
                                            Circle()
                                                .stroke(Color.black, lineWidth: self.selectedColor == colors[index] ? 5 : 3)
                                        )
                                }
                            }
                            .padding(3)
                        }
                }
            .padding(.all)
            
            Button(action: {
                if listName == "" {
                    self.emptyAlert = true
                }else {
                    self.showAlert = true // アラートを表示
                }
            }) {
                Text("リストを追加")
                    .font(.system(size: 20))
                    .padding()
                    .frame(maxWidth: .infinity) // 幅を最大にする
                    .background(Color.blue) // ボタンの背景色
                    .foregroundColor(.white) // テキストの色
                    .cornerRadius(10) // 角丸
                    .shadow(radius: 5) // 影を追加
            }
            .padding(.all)
            .alert("Error", isPresented: $emptyAlert) {
            } message: {
                Text("リスト名を入力してください")
            }
            .alert("List", isPresented: $showAlert) {
                Button("いいえ"){}
                Button("はい") {
                    let newList = ListInfo(name: self.listName, cards: [:], color: self.selectedColor)
                    self.lists.append(newList) // 新しいリストを追加
                    self.presentationMode.wrappedValue.dismiss() // 前の画面に戻る
                }
            } message: {
                Text("'\(listName)' を追加しますか？")
            }
            Spacer() // 追加部分：VStackの最後にSpacerを追加して上に押し上げる
        }
        .padding() // 全体の余白を追加
    }
}

#Preview {
    AddList(lists: .constant([])) // ダミーデータを渡す
}

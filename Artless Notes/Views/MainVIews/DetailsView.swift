//
//  DetailsView.swift
//  Plain Notes
//
//  Created by Md Abir Hossain on 28/1/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct DetailsView: View {
    
    //  MARK: - Order Date Picker
    @State private var date = Date()
    @State private var selectedDate = ""
    
    @State var title: String = ""
    @State var description: String = ""
    
    // PopUp Boolean
    @State var isEdit: Bool = false
    
    @State var datas = Datas()
    
    // Dismiss view
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                
                if !isEdit {
                    Text(title)
                        .font(.title3.weight(.semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .multilineTextAlignment(.leading)
                    
                } else {
                    TextField("TITLE", text: $title)
                        .font(.title3.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .multilineTextAlignment(.leading)
                }
                
                
                if !isEdit {
                    ScrollView([.vertical]) {
//                        Text(description)
//                    DataTextView(text: NSAttributedString(string: description), dataDetectorTypes: [.phoneNumber, .link])
                        DataDetectorTextView(text: description)
                        .font(.title3.weight(.thin))
                        .frame(maxHeight: 200, alignment: .leading)
                        .background(Color("BackgroundColor").opacity(0.5))
                        .multilineTextAlignment(.leading)
                        .aspectRatio(contentMode: .fit)
                        .contextMenu {
                            Button(action: {
                                UIPasteboard.general.string = self.description
                            }) {
                                Text("Copy to clipboard")
                                Image(systemName: "doc.on.doc")
                            }
                        }
                    }
                } else {
                    TextField("Enter description", text: $description, axis: .vertical)
                        .font(.title3.weight(.thin))
                        .background(Color("BackgroundColor").opacity(0.5))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                 
                Spacer()
            }
            .padding()
            .onAppear(perform: {
                title = datas.title ?? ""
                description = datas.description ?? ""
            })
            .overlay(
                HStack {
                    
                    if isEdit {
                        Button(action: {
                            
                            // Undo edit
                            title = datas.title ?? ""
                            description = datas.description ?? ""
                            
                            withAnimation { self.isEdit = false}
                            
                            print("tapped Cancel floating")
                        }, label: {
                            
                            VStack {
                                Text("Cancel")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity, maxHeight: 20)
                                    .padding(20)
                                    .foregroundColor(Color("ButtonFor"))
                                    .background(Color("ButtonBack").opacity(0.6))
                                    .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 5, y: 5)
                                    .shadow(color: Color.white, radius: 5, x: -1, y: -3)
                                    .cornerRadius(20)
                            }
                        })
                    
                    Button(action: {
                        
                        let newData = Datas()
                        
                        
                        if isEdit {
                            DBSqlite().updateNote(datas: datas, tagName: datas.tagName ?? "", title: title, description: description, editDate: datas)
                            self.mode.wrappedValue.dismiss()
                            
                            withAnimation { self.isEdit.toggle() }
                        }
                        
                        print("tapped cancel edit floating")
                    }, label: {
                        
                        VStack {
                            Text(isEdit ? "Save" : "Edit")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, maxHeight: 20)
                                .padding(20)
                                .foregroundColor(Color("ButtonFor"))
                                .background(Color("ButtonBack").opacity(0.6))
                                .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 5, y: 5)
                                .shadow(color: Color.white, radius: 5, x: -1, y: -3)
                                .cornerRadius(20)
                        }
                    })
                    } else {
                        
                        Button(action: {
                            
                            withAnimation { self.isEdit.toggle() }
                            
                            print("tapped edit expand floating")
                        }, label: {
                            
                            VStack {
                                Text(isEdit ? "Save1" : "Edit")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity, maxHeight: 20)
                                    .padding(20)
                                    .foregroundColor(Color("ButtonFor"))
                                    .background(Color("ButtonBack").opacity(0.6))
                                    .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 5, y: 5)
                                    .shadow(color: Color.white, radius: 5, x: -1, y: -3)
                                    .cornerRadius(20)
                            }
                        })
                    }
                }
                    .padding(.horizontal, 50)
                    .padding(.vertical, 50)
                ,alignment: .bottomTrailing
            )
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    
    @State static var title: String = ""
    @State static var description: String = ""
    
    static var previews: some View {
        DetailsView(title: title, description: description)
    }
}

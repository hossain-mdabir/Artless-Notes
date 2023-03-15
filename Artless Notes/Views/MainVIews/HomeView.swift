//
//  HomeView.swift
//  Plain Notes
//
//  Created by Md Abir Hossain on 28/1/23.
//

import SwiftUI


class ViewModel: ObservableObject {
    @Published var isLeftMenuVisible:Bool = false
}

struct HomeView: View {
    
    // Side Menu
    @StateObject var viewModel = ViewModel()
    
    //  MARK: - Order Date Picker
    @State private var date = Date()
    @State private var selectedDate = ""
    
    
    @State var tagName: String = ""
    @State var title: String = ""
    @State var description: String = ""
    
    @State var newTag: Int = 0
    @AppStorage("selectedTag") var selectedTag: String = ""
    @State var selectedNote: String = ""
    
    
    // PopUp Boolean
    @State var isPopUp: Bool = false
    @State var goDetails: Bool = false
    
    // Database
    @State var dbSqlite = DBSqlite()
    @State var noteData = Datas()
    
    @State var tag1 = ""
    @State var title1 = ""
    @State var des1 = ""
    
    @State private var tags: [Tags] = []
    @State private var datas: [Datas] = []
    @State private var selectedDatas = Datas()
    
    // Toast Message
    @State private var isShowAlert = false
    @State private var isToast = false
    @State private var msg: String = ""
    
    // Get tags from DB to show in screen or refresh screen
    private func getTag() {
        self.tags.removeAll()
        
        let tagList: [Tags] = DBSqlite().getTag()
        
        for p in tagList {
            self.tags.append(p)
        }
        print("\(tags.count)--Tags Insertion")
    }
    
    
    // Get datas from DB to show in screen or refresh screen
    private func getData(tag: String) {
        self.datas.removeAll()
        
        let dataList: [Datas] = DBSqlite().getData(tag: tag)
        
        for p in dataList {
            self.datas.append(p)
        }
        print("\(datas.count)--Notes Insertion")
    }
    
    
    private let sideMenuWidth = UIScreen.main.bounds.width - 250
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .opacity(0.7).ignoresSafeArea(.all)
            
            NavigationLink("", destination: DetailsView(datas: noteData), isActive: $goDetails)
            
            ZStack {
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    HStack {
                        Button {
                            
                            self.viewModel.isLeftMenuVisible.toggle()
                            print("SideMenu Button Clicked:- - -")
                            
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .font(Font.body.bold())
                                .foregroundColor(Color.black)
                                .padding()
                        }
                        
                        Text("Plain Notes")
                            .font(.title.weight(.semibold))
                            .foregroundColor(Color.black)
                            .padding(.horizontal)
                        Spacer()
                    }
                    
                    ScrollView(showsIndicators: false) {
                        ForEach(0 ..< datas.count, id: \.self) { data in
                            
                            Button(action: {
                                
                                noteData = datas[data]
                                
                                withAnimation { self.goDetails = true }
                                
                            }, label: {
                                
                                HStack {
                                    VStack(alignment: .leading, spacing: 5) {
                                        HStack  {
                                            
                                            Text(datas[data].title ?? "")
                                                .font(.title3.weight(.semibold))
                                            
                                            Spacer()
                                            
                                            VStack(alignment: .leading) {
                                                Text("Added:     ")
                                                    .font(.system(size: 10, weight: .semibold)) +
                                                Text("\(datas[data].addDate ?? "")")
                                                
                                                    .font(.system(size: 10, weight: .light))
                                                    .foregroundColor(Color.blue)
                                                
                                                // If  not edited yet
                                                if !((datas[data].editDate)?.isEmpty ?? false) {
                                                    Text("Last Edit: ")
                                                        .font(.system(size: 10, weight: .semibold)) +
                                                    
                                                    Text("\(datas[data].editDate ?? "")")
                                                        .font(.system(size: 10, weight: .light))
                                                        .foregroundColor(Color.blue)
                                                }
                                            }
                                        }
                                        
                                        Text(datas[data].description ?? "")
                                            .font(.system(size: 16, weight: .light))
                                            .lineLimit(1)
                                        
//                                        DataDetectorTextView(text: datas[data].description ?? "")
//                                        DataTextView(text: NSAttributedString(string: datas[data].description ?? ""), dataDetectorTypes: [.all])
                                    }
                                    Spacer()
                                    
                                    Button(action: {
                                        
                                        selectedDatas = datas[data]
                                        
                                        withAnimation { self.isShowAlert.toggle() }
                                        
                                    }, label: {
                                        Image(systemName: "trash")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(Color.red.opacity(0.5))
                                            .padding(3)
                                            .background(Color("BackgroundColor").opacity(0.6))
                                            .cornerRadius(10)
                                            .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 5, y: 5)
                                            .shadow(color: Color.white, radius: 5, x: -1, y: -3)
                                    })
                                    .padding(.bottom, -25)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 5)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color("ButtonFor"))
                                .padding(.all, 5)
                                .background(Color("BackgroundColor").opacity(0.6))
                                .cornerRadius(10)
                                .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 5, y: 5)
                                .shadow(color: Color.white, radius: 5, x: -1, y: -3)
                                .padding()
                                
                            })
                        }
                    }
                }
                .overlay(
                    
                        Button(action: {
                            
                            if tags.count == 0 {
                                
                                self.isToast = true
                                self.msg = "Please add a catagory from SideMenu first"
                                print("Please add a catagory from SideMenu first")
                                
                            } else if selectedTag.isEmpty {
                                
                                self.isToast = true
                                self.msg = "Please select catagory from SideMenu"
                                print("Please seleca catagory from SideMenu")
                                
                            } else {
                                
                                title = ""
                                description = ""
                                
                                withAnimation { self.isPopUp.toggle() }
                                
                                print("tapped bottom floating")
                                
                            }
                        }, label: {
                            if !isPopUp {
                                VStack {
                                    FloatingButton()
                                }
                            }
                        })
                        .padding(.horizontal, 50)
                        .padding(.vertical, 50)
                        ,alignment: .bottomTrailing
                    )
            }
            
            sideMenu()
//                .padding(.top, 35)
//                .ignoresSafeArea(.all)
                .onTapGesture {
                    self.viewModel.isLeftMenuVisible.toggle()
                }
            
            
            if isPopUp {
                Color.gray
                    .opacity(0.5)
                popUp()
                    .padding(.vertical, 40)
                    .padding(.horizontal, 20)
            }
        }
        .navigationTitle("Plain Notes")
        .navigationViewStyle(.stack)
        .environmentObject(self.viewModel)
        .onAppear(perform: {
            
            // Get from database
            self.getTag()
            self.getData(tag: selectedTag)
            
        })
        
        
            // Toast Appearance
        .toastNotification(isToast: $isToast, msg: $msg)
        
        
            // Post Alert
                .alert(isPresented: $isShowAlert) {
                    Alert(title: Text("Delete Alert!!"), message: Text("Do you wnat to delete this note?"),
                          primaryButton: Alert.Button.default(Text("Yes")) {
                        
                        tag1 = selectedDatas.tagName ?? ""
                        title1 = selectedDatas.title ?? ""
                        des1 = selectedDatas.description ?? ""
                        
                        deleteNotes()
                        
                    }, secondaryButton: .cancel() {
                    })
                }
        
    }
    
    // MARK: - Add or edit PopUp
    @ViewBuilder
    func popUp() -> some View {
        ZStack {
            
            VStack(spacing: 20) {
                
                TextField("TITLE", text: $title)
                    .font(.title3.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.leading)
                
                
                TextField("Enter description", text: $description, axis: .vertical)
                    .font(.title3.weight(.thin))
                    .background(Color("BackgroundColor").opacity(0.5))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .aspectRatio(contentMode: .fit)
                
                HStack(alignment: .center, spacing: 10) {
                    Button(action: {
                        withAnimation { self.isPopUp.toggle() }
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 30, weight: .bold))
                            .frame(maxWidth: .infinity, maxHeight: 20)
                            .padding(15)
                            .foregroundColor(Color.red)
                            .background(Color("ButtonBack").opacity(0.6))
                            .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 5, y: 5)
                            .shadow(color: Color.white, radius: 5, x: -1, y: -3)
                            .cornerRadius(10)
                    })
                    
                    Button(action: {
                        
                        if tags.count == 0 {
                            
                            self.isToast = true
                            self.msg = "Please add a catagory SideMenu first"
                            print("Please seleca catagory from SideMenu")
                            
                        } else if selectedTag.isEmpty {
                            
                            self.isToast = true
                            self.msg = "Please select catagory from SideMenu"
                            print("Please seleca catagory from SideMenu")
                            
                        } else if title.isEmpty {
                            
                            self.isToast = true
                            self.msg = "Please enter Note title"
                            print("Please enter Note title")
                            
                        } else if description.isEmpty {
                            
                            self.isToast = true
                            self.msg = "Please enter Note description"
                            print("Please enter Note description")
                            
                        } else {
                            
                            var data = Datas()
                            
                            data.tagName = selectedTag
                            data.title = title
                            data.description = description
                            data.addDate = dateFormatter(date: date)
                            data.editDate = ""
                            
                            dbSqlite.insertData(data: data)
                            
                            // Update screen
                            self.getData(tag: selectedTag)
                            
                            withAnimation { self.isPopUp.toggle() }
                            
                        }
                        
                    }, label: {
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 30, weight: .bold))
                            .frame(maxWidth: .infinity, maxHeight: 20)
                            .padding(15)
                            .foregroundColor(Color.green)
                            .background(Color("ButtonBack").opacity(0.6))
                            .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 5, y: 5)
                            .shadow(color: Color.white, radius: 5, x: -1, y: -3)
                            .cornerRadius(10)
                    })
                }
            }
            .padding()
            .background(Color("BackgroundColor")
                .opacity(0.7))
//                .ignoresSafeArea(.all))
            .cornerRadius(10)
        }
    }
    
    
        // MARK: - Add or edit PopUp
        @ViewBuilder
    func sideMenu() -> some View {
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        self.viewModel.isLeftMenuVisible = false
                    }
                }
            }
        ZStack {
            if self.viewModel.isLeftMenuVisible {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Catagory List")
                            .font(.title.weight(.semibold))
                            .foregroundColor(Color.black.opacity(0.5))
                            .padding(.vertical, 20)
                            .padding(.horizontal, 10)
                    }
                    
                    ScrollView(showsIndicators: false) {
                        
                        ForEach(0 ..< tags.count, id: \.self) { tag in
                            
                            Button(action: {
                                
                                selectedTag = tags[tag].tagName ?? ""
                                
                                // Update screen
                                self.getData(tag: selectedTag)
                                
                                // Saving selected tag
                                selectedTag = tags[tag].tagName ?? ""
                                
                                self.viewModel.isLeftMenuVisible.toggle()
                                print("tagList : - \(tags[tag].tagName)")
                                
                            }, label: {
                                HStack {
                                    let sel = print("tagName: \(tags[tag].tagName) selectedTag: \(selectedTag)")
                                    
                                    Text("\(tags[tag].tagName ?? "")")
                                        Spacer()
                                    if tags[tag].tagName == selectedTag {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(Color.blue)
                                    }
                                }
                                .font(.title2.weight(.semibold))
                                .foregroundColor(Color("ButtonFor"))
                                .frame(maxWidth: .infinity, minHeight: 20)
                                .padding(5)
                                .background(Color("BackgroundColor"))
                                .cornerRadius(10)
                                .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 5, y: 5)
                                .shadow(color: Color.white, radius: 5, x: -1, y: -3)
                            })
                            .padding(10)
                        }
                        
                        HStack {
                            TextField("Enter Name", text: $tagName)
                                .font(.title3.weight(.thin))
                                .frame(maxWidth: .infinity, minHeight: 30)
                                .background(Color("BackgroundColor").opacity(0.5))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
//                                .aspectRatio(contentMode: .fit)
                            
                            Button(action: {
                                
                                if tagName.isEmpty {
                                    
                                    self.isToast = true
                                    self.msg = "Please enter catagory name"
                                    print("Please enter catagory name")
                                    
                                } else {
                                    
                                    var tag = Tags()
                                    
                                    tag.tagName = tagName
                                    
                                    dbSqlite.insertTag(tag: tag)
                                    
                                    // Update screen
                                    self.getTag()
                                    
                                    
                                    // Added Tag is now selected one
                                    selectedTag = tagName
                                    self.isToast = true
                                    self.msg = "'\(selectedTag)' is now selected"
                                    print("Added Tag is selected tag -- from SideMenu")
                                    
                                    // Closing side menu
                                    self.viewModel.isLeftMenuVisible.toggle()
                                    
                                    // Inserting empty
                                    tagName = ""
                                }
                                
                            }, label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 16, weight: .bold))
                                    .frame(maxWidth: 30, maxHeight: 30)
                                    .foregroundColor(Color.white)
                                    .background(Color("ButtonBack").opacity(0.6))
                                    .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 5, y: 5)
                                    .shadow(color: Color.white, radius: 5, x: -1, y: -3)
                                    .cornerRadius(10)
                            })
                        }
                        .padding(.horizontal)
                    }
                }
                .frame(maxWidth:.infinity, maxHeight: .infinity)
                .background(Color("BackgroundColor"))
                .cornerRadius(1)
                .padding(.trailing, sideMenuWidth)
                .onTapGesture {
                    self.viewModel.isLeftMenuVisible = true
                }
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .leading),
                        removal: .move(edge: .leading)
                    )
                )
                .zIndex(1)
            }
        }
            .background(Color("BackgroundColor").opacity(0.5))
            .gesture(drag)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.default, value: self.viewModel.isLeftMenuVisible)
    }
    
    
    //  MARK: - Delete  Notes
    func deleteNotes() {
        
        print("selectedTag \(selectedTag) - title1 \(title1) - des1 \(des1)")
        
        dbSqlite.deleteNotes(tag: selectedTag, title: title1)
        
            // Update screen
        self.getData(tag: selectedTag)
    }
    
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(title: "", description: "")
    }
}




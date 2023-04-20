//
//  TipTheDeveloperView.swift
//  Converta
//
//  Created by Ernest Dainals on 12/03/2023.
//

import SwiftUI

struct TipJarView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: ViewModel
    @State private var selectedTip: Tips = .kindTip
    @State private var showSafari: Bool = false
    @State private var isShowingThanksForTheTip: Bool = false
    @State private var isShowingTipTutorial: Bool = false
    var body: some View {
        ScrollView(showsIndicators: false) {
            Text("Converta is being developed by a student. Developing an app and doing all of my school work at the same time is not very easy. A small tip from you will be deeply appreciated. Thank you for your support.")
                .customFont(size: 18, weight: .medium)
                .padding(.horizontal)
            
            Divider().padding(.horizontal).padding(.vertical, 5).padding(.bottom, 10)
            
            ForEach(Tips.allCases, id: \.self) { tip in
                let Tip = tip.getTip()
                
                Button {
                    withAnimation {
                        self.selectedTip = tip
                        HapticManager.shared.impact(style: .soft)
                    }
                } label: {
                    HStack {
                        Text(Tip.emoji)
                            .customFont(size: 40)
                        
                        Text(Tip.name)
                            .customFont(size: 20, weight: .medium, design: .rounded)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text(Tip.amountInWon)
                            .customFont(size: 18, weight: .medium, design: .rounded)
                            .foregroundColor(.primary)
                    }.padding().background(selectedTip == tip ? Color.brandPurple4.opacity(0.6) : Color(.systemGray6)).cornerRadius(15).padding(.horizontal)
                }
            }
            
            Spacer(minLength: 170)
        }
        .navigationTitle("Tip Jar")
        .overlay(alignment: .bottom) {
            VStack(alignment: .leading) {
                HStack {
                    Text("Tip Amount: \(selectedTip.getTip().amountInWon)")
                        .customFont(size: 21, weight: .semibold)
                    
                    Spacer()
                    
                    Button {
                        self.isShowingTipTutorial = true
                        HapticManager.shared.impact(style: .soft)
                    } label: {
                        Image(systemName: "questionmark.circle")
                            .imageScale(.large)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("TossBlue"))
                    }
                }
                
                Button {
                    showSafari = true
                    HapticManager.shared.impact(style: .soft)
                } label: {
                    HStack(spacing: -20) {
                        Text("Tip with")
                            .customFont(size: 22, weight: .bold)
                            .foregroundColor(.white)
                        
                        Image("Toss_Logo_Reverse")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 25)
                    }.offset(x: 20).alignView(to: .center).padding().background(Color("TossGray")).cornerRadius(10)
                }.scaleButtonStyle(scaleAmount: 0.98)
            }.padding().background(Material.thin)
        }
        .overlay {
            ZStack {
                if isShowingThanksForTheTip {
                    Color.black.opacity(0.8)
                        .onTapGesture {
                            withAnimation {
                                self.isShowingThanksForTheTip = false
                                HapticManager.shared.impact(style: .soft)
                            }
                        }
                        .transition(.opacity)
                }

                if isShowingThanksForTheTip {
                    VStack(spacing: 10) {
                        Text("🙏")
                            .customFont(size: 60)
                        
                        Text("Thanks you for the tip.")
                            .customFont(size: 20, weight: .semibold, design: .rounded)
                        
                        Text("I'll do my best to make Converta even better.")
                            .opacity(0.7)
                            .multilineTextAlignment(.center)
                    }
                    .frame(height: 300).padding().padding(.horizontal, 30).background(Material.ultraThin).cornerRadius(15)
                    .transition(.opacity.combined(with: .offset(y: 25)))
                    .onAppear {
                        HapticManager.shared.notification(type: .success)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                self.isShowingThanksForTheTip = false
                                HapticManager.shared.impact(style: .soft)
                            }
                        }
                    }
                    .onTapGesture {
                        withAnimation {
                            self.isShowingThanksForTheTip = false
                            HapticManager.shared.impact(style: .soft)
                        }
                    }
                }
            }.ignoresSafeArea()
        }
        .sheet(isPresented: $showSafari) {
            SFSafariViewWrapper(url: URL(string: "https://toss.me/ernest/\(selectedTip.getTip().price)")!)
                .onDisappear { withAnimation { self.isShowingThanksForTheTip = true } }
        }
        .sheet(isPresented: $isShowingTipTutorial) { tipTutorialView }
    }
    
    var tipTutorialView: some View {
        NavigationStack {
            ScrollView {
                Image(colorScheme == .light ? "Toss_Logo_Primary" : "Toss_Logo_Reverse")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 80)
                
                Text("You need to have a Toss app installed on your device in order to send me the tip.")
                    .customFont(size: 20, weight: .semibold)
                    .multilineTextAlignment(.leading)
                    .alignView(to: .leading)
                    .padding(.horizontal)
                
                Text("Toss may not be available in certain countries or regions.")
                    .alignView(to: .leading)
                    .padding(.horizontal)
                    .foregroundColor(.secondary)
                
                Divider().padding([.horizontal, .bottom])
                
                HStack {
                    Link(destination: URL(string: "https://toss.im/en")!) {
                        VStack {
                            Image(systemName: "character.bubble.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.blue)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.brandPurple3)
                            
                            Text("Visit Toss Website")
                                .customFont(size: 18, weight: .semibold)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.4)
                            
                            Text("(English)")
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.4)
                            
                            Text("Click here")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .offset(y: 10)
                        }.alignView(to: .center).frame(height: 120).padding().padding(.vertical).background(Material.ultraThin).cornerRadius(15).padding(.leading)
                    }
                    
                    Link(destination: URL(string: "https://toss.im")!) {
                        VStack {
                            Image(systemName: "character.bubble.fill.ko")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.blue)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.brandPurple3)
                            
                            Text("토스 홈페이지 방문하기")
                                .customFont(size: 18, weight: .semibold)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.4)
                            
                            Text("(Korean)")
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.4)
                            
                            Text("여기를 클릭")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .offset(y: 10)
                        }.alignView(to: .center).frame(height: 120).padding().padding(.vertical).background(Material.ultraThin).cornerRadius(15).padding(.trailing)
                    }
                }
                
                Divider().padding()
                
                VStack(spacing: 20) {
                    Text("After installing Toss, when you tap \"Pay with Toss\" on the Tip Jar, you'll see this screen.")
                        .customFont(size: 20, weight: .semibold)
                        .multilineTextAlignment(.leading)
                        .alignView(to: .leading)
                        .padding(.horizontal)
                    
                    Image("Toss_Tutorial_Image")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15)
                        .padding(.horizontal)
                    
                    Text("Please tap \"익명 송금하기\".")
                        .customFont(size: 20, weight: .semibold)
                        .multilineTextAlignment(.leading)
                        .alignView(to: .leading)
                        .padding(.horizontal)
                    
                    Image("Toss_Tutorial_Image_2")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15)
                        .padding(.horizontal)
                    
                    Text("The text field allows you to change your nickname. It will be filled automatically.")
                        .customFont(size: 20, weight: .semibold)
                        .multilineTextAlignment(.leading)
                        .alignView(to: .leading)
                        .padding(.horizontal)
                    
                    Text("Tap \"확인\".")
                        .customFont(size: 20, weight: .semibold)
                        .multilineTextAlignment(.leading)
                        .alignView(to: .leading)
                        .padding(.horizontal)
                    
                    Text("After you get redirected to the Toss app, you'll see this screen.")
                        .customFont(size: 20, weight: .semibold)
                        .multilineTextAlignment(.leading)
                        .alignView(to: .leading)
                        .padding(.horizontal)
                    
                    Image("Toss_Tutorial_Image_3")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15)
                        .padding(.horizontal)
                    
                    Text("It is a confirmation screen to make sure you want to send the money to me. Please confirm the amount again, and tap \"보내기\"")
                        .customFont(size: 20, weight: .semibold)
                        .multilineTextAlignment(.leading)
                        .alignView(to: .leading)
                        .padding(.horizontal)
                    
                    VStack(spacing: 5) {
                        Text("🙏")
                            .customFont(size: 50)
                        
                        Text("And that's it!")
                            .customFont(size: 25, weight: .bold)
                        
                        LinearGradient(colors: [.brandPurple2, .brandPurple4], startPoint: .topLeading, endPoint: .bottomTrailing)
                            .mask {
                                Text("Thank you so much for your support.")
                                    .customFont(size: 30, weight: .heavy)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.4)
                            }
                            .frame(minHeight: 23)
                    }.padding(.top, 50).padding(.bottom)
                }
            }
            .navigationTitle("Help")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Done") {
                    self.isShowingTipTutorial = false
                    HapticManager.shared.impact(style: .soft)
                }.fontWeight(.semibold)
            }
        }
    }
}

struct TipTheDeveloperview_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TipJarView()
                .environmentObject(ViewModel())
        }
    }
}

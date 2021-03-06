//
//  ProfileHost.swift
//  SampleFit
//
//  Created by Zihan Qi on 3/7/21.
//

import SwiftUI

struct ProfileHost: View {
    @ObservedObject var publicProfile: PublicProfile
    @State private var isEditing = false
    
    init(publicProfile: PublicProfile) {
        self.publicProfile = publicProfile
    }
    
    var body: some View {
        ScrollView {    // scrolling experience is a bit better
            DetailedProfileSummary(publicProfile: publicProfile)
        }
        .sheet(isPresented: $isEditing) {
            ProfileEditor(publicProfile: publicProfile, isPresented: $isEditing)
        }
        .toolbar {
            Button(action: { self.isEditing.toggle() }) {
                Text("Edit")
            }
        }
        .navigationBarTitle("Profile Details", displayMode: .inline)
    }
}


struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        MultiplePreview(embedInNavigationView: true) {
            ProfileHost(publicProfile: PublicProfile.exampleProfile)
        }
    }
}

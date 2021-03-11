//
//  ExerciseBrowseView.swift
//  SampleFit
//
//  Created by apple on 3/11/21.
//

import SwiftUI

struct WorkoutBrowseView: View {
    @EnvironmentObject var privateInformation: PrivateInformation
    
    var body: some View {
      
        let columns=[GridItem(.flexible()),GridItem(.flexible())]
        
        VStack(alignment: .leading){
        NavigationView{
            
            LazyVGrid(columns: columns, spacing:15 ){
            ForEach(Exercise.Category.allCases, id: \.self) { category in
                NavigationLink(destination: WorkoutView(categoryName:category.description)) {
                    CategorySquareView(categoryName: category.description)
        }
            }
            
        }
        
        
        }
       
}
    }}


struct WorkoutBrowseView_Previews: PreviewProvider {
    static var userData = UserData()
    static var previews: some View {
        WorkoutBrowseView().environmentObject(userData)
            .environmentObject(userData.privateInformation)
    }
}

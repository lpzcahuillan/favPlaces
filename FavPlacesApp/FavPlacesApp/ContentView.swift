//
//  ContentView.swift
//  FavPlacesApp
//
//  Created by Hugo López on 16-06-24.
//

import SwiftUI
import MapKit


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: .init())
    private var items: FetchedResults

    @State var position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -33.4433764, longitude: -70.6539788), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)))
    @State var places:[Place] = []
    @State var showPopUp:CLLocationCoordinate2D?=nil
    @State var name:String=""
    @State var fav:Bool = false
    @State var showSheet = false
    let height = stride(from: 0.3, through: 0.3, by: 0.1).map{ PresentationDetent.fraction($0)}
    
    var body: some View {
        ZStack {
            MapReader{
                proxy in Map(position: $position){
                    ForEach(places){ place in
                        Annotation(place.name, coordinate: place.coordinates) {
                            let color = if place.fav{
                                Color.yellow
                            }else {
                                Color.black
                            }
                            Circle().fill(color)
                        }
                    }
                }
                    .onTapGesture { coord in
                        if let coordinates = proxy.convert(coord, from: .local){
                            showPopUp = coordinates
                        }
                }
                
            }.overlay{
                VStack{
                    Button("Show list"){
                        showSheet = true
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.white)
                    .cornerRadius(16)
                    .padding(16)
                    
                    Spacer()
                }
            }
            if showPopUp != nil{
                withAnimation {
                    popUpScene()
                }
            }
                
        }.sheet(isPresented: $showSheet){
            Text("Tus lugares favoritos").font(.title2).bold().padding()
            horizontalList()
        }
    }
    func popUpScene() -> some View {
        let view = VStack{
            Text("Añadir localización").font(.title2).bold()
            Spacer()
            TextField("Agrega nombre de la ubicación", text: $name)
            Toggle(isOn: $fav, label: {
                Text("¿Es un lugar favorito?")
            })
            Spacer()
            Button("Guardar") {
                if name != "" {
                    savePlace(name: name, fav: fav, coordinate: showPopUp!)
                    clearForm()
                }
                
            }
        }
        return CustomDialog(closeDialog: {self.showPopUp = nil}, onDismissOutside: true, content: view)
    }
    
    func savePlace(name:String, fav:Bool, coordinate:CLLocationCoordinate2D) {
        
        let place = Place(name: name, coordinates: coordinate, fav: fav)
        places.append(place)
    }
    
    func horizontalList() -> some View {
        let view = ScrollView(.horizontal){
                LazyHStack{
                    ForEach(places){ place in
                        let Color = if place.fav{
                            Color.yellow
                        }else {
                            Color.black
                        }
                        VStack{
                            Text(place.name).font(.title3).bold()
                        }
                        .frame(width: 150, height: 100)
                        .overlay{
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color, lineWidth: 2)
                        }
                        .shadow(radius: 5)
                        .onTapGesture {
                            animateCamera(coordinate: place.coordinates)
                            showSheet = false
                        }
                    }
                }
            }.presentationDetents(Set(height))
        return view
    }
    
    func animateCamera(coordinate:CLLocationCoordinate2D){
        withAnimation{
            position = MapCameraPosition.region(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
        }
    }
    
    func clearForm(){
        name=""
        fav=false
        showPopUp=nil
    }
}

#Preview {
    ContentView()
}

import SwiftUI
import CoreData

struct LocationList: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @Environment(\.managedObjectContext) var moc

    var requestLocations : FetchRequest<Location>
    var locationList : FetchedResults<Location>{requestLocations.wrappedValue}

    var selectedCustomer: Customer

    init(selectedCustomer: Customer){
        
        self.selectedCustomer = selectedCustomer
        
        self.requestLocations = FetchRequest(
            entity: Location.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "fromCustomer.id == %@", selectedCustomer.id!)
        )

    }
    
    var btnNewLocation : some View { Button(action: {

        let object = Location(context: self.moc)
        object.id = UUID().uuidString
        object.address = UUID().uuidString
        self.selectedCustomer.numberOfLocations += 1
        object.fromCustomer = self.selectedCustomer
                
        try? self.moc.save()
        
    })  {
        Image(systemName: "plus.circle.fill")
        }
    }

    var body: some View {
        
        VStack{
            
            List{

                ForEach(locationList, id: \.id) { location in

                    VStack(alignment: .leading){
                        Text("\(location.address ?? "?")").font(.headline)
                        .onTapGesture {

                            print("Tapped and changed selected parent object")
                            
                            self.selectedCustomer.name = "Changed"
                            
                            try? self.moc.save()
                            
                            self.presentationMode.wrappedValue.dismiss()
                            
                        }

                    }.padding()

                }
                .onDelete(perform: remove)

            }
            

        }
        .navigationBarTitle(Text("\(selectedCustomer.name ?? "?")"), displayMode: .inline)
        .navigationBarItems(trailing: btnNewLocation)
    }
    
    private func remove(at offsets: IndexSet) {
        
        for index in offsets {
            
            let obj = locationList[index]
                        
            self.moc.delete(obj)

        }
        
        self.selectedCustomer.numberOfLocations -= 1
        
        try? self.moc.save()

    }

}

struct LocationList_Previews: PreviewProvider {
    static var previews: some View {
        CustomerList()
    }
}

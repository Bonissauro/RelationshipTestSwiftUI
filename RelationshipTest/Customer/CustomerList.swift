import SwiftUI
import CoreData

struct CustomerList: View {

    @Environment(\.managedObjectContext) var moc

    @FetchRequest(
        entity: Customer.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Customer.name, ascending: true),
        ]
    ) var customerList: FetchedResults<Customer>

    var btnCreate : some View { Button(action: {

        // FIRST CUSTOMER
        let customer1 = Customer(context: self.moc)
        customer1.id = UUID().uuidString
        customer1.name = "ASDJJ SJDBSJ SJD"
        customer1.numberOfLocations = 0
        
        let loc11 = Location(context: self.moc)
        loc11.id = UUID().uuidString
        loc11.address = "SDKJSJS DSMDJ AKLSD"
        customer1.numberOfLocations += 1
        loc11.fromCustomer = customer1

        let loc12 = Location(context: self.moc)
        loc12.id = UUID().uuidString
        loc12.address = "WKE DMF MD M DMDS"
        customer1.numberOfLocations += 1
        loc12.fromCustomer = customer1

        let loc13 = Location(context: self.moc)
        loc13.id = UUID().uuidString
        loc13.address = "SKDJFD SDASH DHASD "
        customer1.numberOfLocations += 1
        loc13.fromCustomer = customer1

        // SECOND CUSTOMER
        let customer2 = Customer(context: self.moc)
        customer2.id = UUID().uuidString
        customer2.name = "SDKLS JHSGDJH ASHJDHJS "
        customer2.numberOfLocations = 0

        let loc21 = Location(context: self.moc)
        loc21.id = UUID().uuidString
        loc21.address = "KDKJH SDK JFH"
        customer2.numberOfLocations += 1
        loc21.fromCustomer = customer2

        // THIRD CUSTOMER
        let customer3 = Customer(context: self.moc)
        customer3.id = UUID().uuidString
        customer3.name = "AKJSDJ ASMNB MSNDB"
        customer3.numberOfLocations = 0
        
        let loc31 = Location(context: self.moc)
        loc31.id = UUID().uuidString
        loc31.address = "SJDHKJ SDJKKLA 1"
        customer3.numberOfLocations += 1
        loc31.fromCustomer = customer3

        let loc32 = Location(context: self.moc)
        loc32.id = UUID().uuidString
        loc32.address = "EII UREISK DKS 2"
        customer3.numberOfLocations += 1
        loc32.fromCustomer = customer3

        try? self.moc.save()
        
    })  {
        Image(systemName: "gear")
                .resizable()
        }
    }

    var btnNew : some View { Button(action: {

        let obj = Customer(context: self.moc)
        obj.id = UUID().uuidString
        obj.name = UUID().uuidString
        obj.locationList = NSSet()
        obj.numberOfLocations = 0
        
        try? self.moc.save()
        
    })  {
        Image(systemName: "plus.circle.fill")
                .resizable()
        }
    }

    var body: some View {
        
        VStack{
            CustomerArea
        }
        .navigationBarTitle(Text("Customers"), displayMode: .inline)
        .navigationBarItems(leading: btnCreate, trailing: btnNew)

    }
    
    var CustomerArea: some View {
        
        List{
         
            ForEach(customerList, id: \.id) { customer in
                
                NavigationLink(
                    destination: LocationList(selectedCustomer: customer)
                ) {
                    VStack(alignment: .leading){
                        
                        Text("\(customer.name ?? "?")").font(.headline)
                        
                        LocationCell(customer: customer)
                        
                    }.padding()
                }

            }.onDelete(perform: self.remove)

        }
        
    }
    
    private func remove(at offsets: IndexSet) {
        
        for index in offsets {
            let obj = customerList[index]
            self.moc.delete(obj)
        }
        
        try? self.moc.save()

    }
        
}

struct LocationCell: View {

    let customer: Customer
    
    var body: some View {

        HStack{
         
            Spacer()
            Text("Locations: \(customer.locationList?.count ?? 0) / \(customer.numberOfLocations)")
                .font(.footnote)
            
        }

    }
    
}

struct CustomerList_Previews: PreviewProvider {
    static var previews: some View {
        CustomerList()
    }
}

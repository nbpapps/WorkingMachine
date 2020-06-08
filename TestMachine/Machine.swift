//
//  Machine.swift
//  TestMachine
//
//  Created by niv ben-porath on 27/05/2020.
//  Copyright © 2020 nbpApps. All rights reserved.
//

import Foundation

//each machine can run only one test at a time
class Machine {
    var isAvailable = true
    let id : String
    private var queue = DispatchQueue(label: "machineQueue", attributes: .concurrent)

    
    
    init(id : String) {
        self.id = id
    }
    
    func testToRun(_ test : Test, with completion : @escaping (String,String)-> Void) {
        
        isAvailable = false//the machine is not available for tests
        
        print("Machine \(self.id) running test \(test.id)")
        
        //RUN TEST
        //here we added asyncAfter to simulate work done by the machine
        
        run(test: test) { [weak self] in
            
            guard let self = self else { return }
            print("Machine \(String(describing: self.id)) finished test \(test.id)")
            self.isAvailable = true // once work is done, the machine is available
            completion(self.id,test.id)//when we complete, we return the test id so we know this test has finished running
        }
    }
    
    private func run(test : Test, with completion : @escaping ()->Void) {
        queue.async {
//            DispatchQueue.main.asyncAfter(deadline: .now()) {
                completion()
//            }
        }
        
    }
    
}

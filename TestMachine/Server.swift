//
//  Server.swift
//  TestMachine
//
//  Created by niv ben-porath on 27/05/2020.
//  Copyright © 2020 nbpApps. All rights reserved.
//

import Foundation

class Server {
    
    var machineArray = [Machine(id: "A"),Machine(id: "B"),Machine(id: "C")]
    var listOfTests = [Test]()
    var runningTests = [Test]()
    var isActive = false
    
//    init(machineArray : [Machine]) {
//        self.machineArray = machineArray
//    }
    
    init() {
//        machineArray  = [m1,m2,m3]
    }
    
    //This is a handler that gets the tests that the server needs to run on machines
    func receiveTests(_ tests : [Test]) {
        //we add new tests to the end of the list
        listOfTests.append(contentsOf: tests)
        if !isActive {//if the server is not active, we start
            start()
        }
    }
    
    private func start() {
        isActive = true
        //run test while we still have some in our list
        while listOfTests.count > 0 {
            runTests()
        }
    }
    
    private func runTests() {
        //find the first machine that is free
        guard let freeMachine = machineArray.first(where: { (machine) -> Bool in
            return machine.isAvailable
        }) else {
            return
        }
        
        //make sure we have at least one test
        guard let nextTest = listOfTests.first else {
            return
        }
        
        listOfTests.removeFirst()       //remove that test
        runningTests.append(nextTest)   //and save it to the running list
        
        
        //call the test on the machine
        freeMachine.testToRun(nextTest) { [weak self] (testId) in
            guard let self = self else {return}
            //when we complete, we find the first test that has the id of the test that was returned, and remove it from the running tests (if it failed, we could return it to the main list)
            if let finishedTestIndex = self.runningTests.firstIndex(where: { (test) -> Bool in
                test.id == testId
            }) {
                self.runningTests.remove(at: finishedTestIndex)
            }
        }
    }
    
    
}

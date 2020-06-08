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
    
    private var machineQueue = DispatchQueue(label: "machineArrayQueue", attributes: .concurrent)
    private var testsQueue = DispatchQueue(label: "testsQueue", attributes: .concurrent)
    private var runningTestsQueue = DispatchQueue(label: "runningTestsQueue", attributes: .concurrent)
    
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
            self.runTests()
        }
    }
    
    private func runTests() {
        //find the first machine that is free
        guard let freeMachine = getFreeMachine() else {
            return
        }
        
        //make sure we have at least one test
        guard let nextTest = getNextTest() else {
            return
        }
        
        //call the test on the machine
        freeMachine.testToRun(nextTest) { [weak self] (machineId, testId) in
            guard let self = self else {return}
            //when we complete, we find the first test that has the id of the test that was returned, and remove it from the running tests (if it failed, we could return it to the main list)
            self.updateRun(for: testId)
            
        }
    }
    
    
    private func updateRun(for testId : String) {
        machineQueue.sync(flags: .barrier) {
            if let finishedTestIndex = self.runningTests.firstIndex(where: { (test) -> Bool in
                test.id == testId
            }) {
                
                self.runningTests.remove(at: finishedTestIndex) //remove test that has passed
                //                let firstMachine = self.machineArray.removeFirst()
                //                self.machineArray.append(firstMachine)
            }
        }
    }
    
    private func getFreeMachine() -> Machine? {
        machineQueue.sync {
            guard let freeMachine = machineArray.first(where: {$0.isAvailable}) else {
                return nil
            }
            return freeMachine
        }
    }
    
    private func getNextTest() -> Test? {
        testsQueue.sync(flags: .barrier) {
            guard let nextTest = listOfTests.first else {
                return nil
            }
            
            listOfTests.removeFirst()       //remove that test
            runningTestsQueue.sync(flags: .barrier) {
                runningTests.append(nextTest)   //and save it to the running list
                
            }
            return nextTest
        }
    }
    
    
    
}

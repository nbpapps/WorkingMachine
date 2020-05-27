//
//  ViewController.swift
//  TestMachine
//
//  Created by niv ben-porath on 27/05/2020.
//  Copyright © 2020 nbpApps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configServer()
    }
    
    func configServer() {
//        let machine1 = Machine()
//        let machine2 = Machine()
//        let machine3 = Machine()
//
//        let machines : [Machine] = [machine1,machine2,machine3]
        let server = Server()
        
        
        let tests : [Test] = [
            Test(id: "1"),
            Test(id: "2"),
            Test(id: "3"),
            Test(id: "4"),
            Test(id: "5"),
            Test(id: "6"),
            Test(id: "7"),
        ]
        
        server.receiveTests(tests)
    }


}


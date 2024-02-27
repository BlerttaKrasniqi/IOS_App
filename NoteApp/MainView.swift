//
//  MainViewViewController.swift
//  NoteApp
//
//  Created by Blerta on 2/26/24.
//

import UIKit

class MainView: UIViewController {
    
  //  @IBOutlet weak var darkMode: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
     //   darkMode.isOn = traitCollection.userInterfaceStyle == .dark
    }
    
  /*  @IBAction func turnToDark(_ sender: Any){
        let isDarkModeEnabled = sender.isOn
        let overrideUIStyle: UIUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
        UIApplication.shared.windows.first?.rootViewController?.overrideUserInterfaceStyle = overrideUIStyle    }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

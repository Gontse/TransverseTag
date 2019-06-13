//
//  VenueDetailViewController.swift
//  TransverseTag
//
//  Created by Gontse Ranoto on 2018/11/17.
//  Copyright © 2018 Gontse Ranoto. All rights reserved.
//

import UIKit


struct VenueDetails {
    
    let Id: String
    let name: String
    let address: String
    let description:String
    let phoneNumber: String
    
    init(Id: String, name:String, address: String, description: String?, phoneNumber: String?) {
        
        self.Id = Id
        self.name = name
        self.address = address
        self.description = description  ?? "Sorry the venue manager(s) have not yet provided any description about the venue"
        self.phoneNumber = phoneNumber ?? "No phone number"
        
    }
}

class VenueDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var vId = ""
    var vName = ""
    var vCategory = ""
    var vAddress = ""
    var vDescription = ""
    var vPhoneNumber = ""
    var vBestImgStr = ""
   
    
    @IBOutlet weak var _tableView: UITableView!
    
    @IBOutlet weak var nameLabel: UILabel!{
        didSet{
            nameLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var categoryLabel: UILabel! {
        didSet{
            categoryLabel.layer.cornerRadius = 5.0
        }
    }
    @IBOutlet weak var bestImageView: UIImageView!
    
    @IBOutlet weak var moreImagesButton: UIButton!{
       
        didSet{
            moreImagesButton.layer.cornerRadius = 7.0
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        _tableView.separatorStyle = .none

        nameLabel.text = vName
        categoryLabel.text = vCategory
        
        
        if vCategory == ""{
            vCategory = "Not Specified"
        }
        
        if vDescription == ""{
            vDescription = "Sorry the venue manager(s) have not yet provided any description about the venue, We hope there will be a  venue discription of sort provided sooner or later."
        }
        
        if  vPhoneNumber == ""{
            vPhoneNumber = "Not Specified"
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = .white
  
        _tableView.estimatedRowHeight = 95.0
        _tableView.contentInsetAdjustmentBehavior = .never
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func GetMoreImages(_ sender: Any) {
    
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VenueImage") as? VenueImageTableViewController{
            if let navigator = navigationController {
                
                navigator.pushViewController(viewController, animated: true)
              }
        }
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
    switch indexPath.row {
        
    case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: VenueDetailIconCell.self), for: indexPath) as! VenueDetailIconCell
            cell.icon.image = UIImage(named: "phone")
            cell.detailLabel?.text = vPhoneNumber
            cell.selectionStyle = .none

            return cell
    case 1:
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: VenueDetailIconCell.self), for: indexPath) as! VenueDetailIconCell
        cell.icon.image = UIImage(named: "map")
        cell.detailLabel.text = vAddress //"Level 3 The Quarterdeck, 69 Richefond Circle, Ridgeside Office Park, Umhlanga, 4321, South Africa"
        cell.selectionStyle = .none
        
        return cell
        
    case 2:
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: VenueDetailCell.self), for: indexPath) as! VenueDetailCell
        
        cell.descriptionLabel.text = vDescription //"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum"
        cell.selectionStyle = .none
        
        return cell
        default:
            fatalError("Failed to instatiate the table view cell for venue detail")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

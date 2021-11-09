//
//  ViewController.swift
//  ProximityBusinessDemo
//
//  Created by Josh Holton on 11/1/21.
//

import UIKit
import Foundation

class ViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableUsers: UITableView!
    @IBOutlet weak var tableBusinessPartners: UITableView!
    @IBOutlet weak var tableVerificationType: UITableView!
    @IBOutlet weak var textViewMessage: UITextView!
    @IBOutlet weak var textViewPeerMessage: UITextView!
    
    @IBOutlet weak var tableVerificationStrategy: UITableView!
    @IBOutlet weak var tablePeerUsers: UITableView!
    
    var verificationTypes = NSMutableArray()
    var verificationStrategies = NSMutableArray()
    var businessPartners = [String]()
    var users = [String]()
    
    var userPhoneNumber : String = String()
    var peerUserPhoneNumber : String = String()
    //BizPartnersLoaded
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.toggleActivityIndicatorView(title: "LOADING", show: true, withCompletion: {})
        
        loadUsers()
        loadGetBusinessPartners()
        loadVerificationTypes()
        loadVerificationStrategies()
        
        // Do any additional setup after loading the view.
        tableUsers.delegate = self
        tableUsers.dataSource = self
        
        tableBusinessPartners.delegate = self
        tableBusinessPartners.dataSource = self
        
        tableVerificationType.delegate = self
        tableVerificationType.dataSource = self
        
        tableVerificationStrategy.delegate = self
        tableVerificationStrategy.dataSource = self
        
        tablePeerUsers.delegate = self
        tablePeerUsers.dataSource = self
        
        //NotificationCenter.default.addObserver(self, selector: #selector(self.bizPartnersLoaded(_:)),
        //                                       name: NSNotification.Name(rawValue: "BizPartnersLoaded"), object: nil)
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.bizPartnersLoaded),
                                               name: NSNotification.Name(rawValue: "BizPartnersLoaded"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.userLoaded),
                                               name: NSNotification.Name(rawValue: "UserLoaded"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.businessCaseRequestFinished),
                                               name: NSNotification.Name(rawValue: "BusinessCaseRequestFinished"), object: nil)
        
        
    
    }


    func loadUsers() {
        users.removeAll()
        users.append("+17732944095")
        users.append("+18474567678")
        users.append("+15551234567")
        
        tableUsers.reloadData()
        
        _ = User.Helper.getExistingUser(userPhone: "+17732944095")
        _ = User.Helper.getExistingUser(userPhone: "+18474567678")
        _ = User.Helper.getExistingUser(userPhone: "+15551234567")
    }
    
    func loadGetBusinessPartners() {
        _ = BizPartners.getBizPartners()
        //var user = User.Helper.
    }
    
    func loadVerificationTypes() {
        verificationTypes.removeAllObjects()
        verificationTypes.add("Transaction")
        verificationTypes.add("Identity")
        verificationTypes.add("AccountRecovery")
        verificationTypes.add("Password")
    }
    
    func loadVerificationStrategies() {
        verificationStrategies.removeAllObjects()
        verificationStrategies.add("JustUser")
        verificationStrategies.add("Multi")
    }
    
    func toggleActivityIndicatorView(title: String, show : Bool, withCompletion:()-> Void){
        if (show){
            //DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.startWaitingView(title: title)
            //}
            withCompletion()
        }
        else {
            self.stopWaitingViewWithFadeout()
            
            withCompletion()
        }
    }
    
    
    
    @IBAction func clickedSendRequest(_ sender: Any) {
        self.toggleActivityIndicatorView(title: "SAVING", show: true, withCompletion: {})
        
        let selectedUserIndexPath = self.tableUsers.indexPathForSelectedRow
        let currentUserCell = self.tableUsers.cellForRow(at: selectedUserIndexPath!) as! UserCell
        userPhoneNumber = currentUserCell.labelName.text!
        
        //_ = User.Helper.getExistingUser(userPhone: userPhoneNumber)
      
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        
        let user = appDelegate?.dictUsers[userPhoneNumber] as! User
            //User.Local.getUser(groupName: nil)
        
        let selectedBusinessPartnerIndexPath = self.tableBusinessPartners.indexPathForSelectedRow
        let currentBusinessPartnerCell = self.tableBusinessPartners.cellForRow(at: selectedBusinessPartnerIndexPath!) as! BusinessPartnerCell
        let businessPartnerName = currentBusinessPartnerCell.labelName?.text
        let businessPartnerId = self.getBusinessPartnerId(businessPartnerName: businessPartnerName!)
        
        if businessPartnerId != "none" {
            let businessPartnerCase : BizPartners.BusinessPartnerCase = BizPartners.BusinessPartnerCase()
            businessPartnerCase.CreatedTimestamp = TimeHelper.currentUTC()
            businessPartnerCase.PartnerId = businessPartnerId
            businessPartnerCase.Id = businessPartnerCase.CreatedTimestamp + "-" + businessPartnerCase.PartnerId
            businessPartnerCase.UserId = user.Id
            
            let selectedVerificationTypeIndexPath = self.tableVerificationType.indexPathForSelectedRow
            let currentVerificationTypeCell = self.tableVerificationType.cellForRow(at: selectedVerificationTypeIndexPath!) as! VerificationTypeCell
            let verificationTypeName = currentVerificationTypeCell.labelType?.text
            
            let selectedVerificationStrategyIndexPath = self.tableVerificationStrategy.indexPathForSelectedRow
            let currentVerificationStrategyCell = self.tableVerificationStrategy.cellForRow(at: selectedVerificationStrategyIndexPath!) as! VerificationTypeCell
            let verificationStrategy = currentVerificationStrategyCell.labelType?.text
            
            businessPartnerCase.VerificationType = verificationTypeName
            businessPartnerCase.VerificationStrategyType = verificationStrategy
            
            businessPartnerCase.Message = self.textViewMessage.text
            businessPartnerCase.AcceptCode = "accept123"
            businessPartnerCase.DeclineCode = "fail123"
            
            businessPartnerCase.Status = "none"
            businessPartnerCase.ServerReceivedTime = "none"
            businessPartnerCase.ExpiredInMilliseconds = "120000" //60000
            
            var peerUser : User = User()
            
            let selectedUserIndexPath = self.tablePeerUsers.indexPathForSelectedRow
            let currentPeerUserCell = self.tablePeerUsers.cellForRow(at: selectedUserIndexPath!) as! UserCell
            peerUserPhoneNumber = currentPeerUserCell.labelName.text!
            
            peerUser = appDelegate?.dictUsers[peerUserPhoneNumber] as! User
            
            /*
            if user.Phone == "+17732944095" {
                peerUser = appDelegate?.dictUsers["+15551234567"] as! User
            }
            else if user.Phone == "+18474567678" {
                peerUser = appDelegate?.dictUsers["+17732944095"] as! User
            }
            else {
                peerUser = appDelegate?.dictUsers["+17732944095"] as! User
            }
            */
            
            _ = BizPartners.saveBusinessCase(user: user, peerUser: peerUser, businessCase: businessPartnerCase, peerMessage: self.textViewPeerMessage.text)
        }
        //self.toggleActivityIndicatorView(title: "LOADING", show: false, withCompletion: {})
    }

@objc func businessCaseRequestFinished() {
    DispatchQueue.main.async {
        self.toggleActivityIndicatorView(title: "SENDING", show: false, withCompletion: {})
        
        let finishedAlert = UIAlertController(title: "Business Partner Request",
                                             message: "The request was sent Successfully." , preferredStyle: UIAlertController.Style.alert)
        
        finishedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
           
        }))
        
        self.present(finishedAlert, animated: true, completion: nil)
    }
}
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        /*
        let sectionName: String
        
        if (filteredClosedProxVerifications.count > 0) {
            sectionName = NSLocalizedString("Closed", comment: "Closed")
        }
        else {
            //sectionName  = NSLocalizedString("No Closed Requests", comment: "No Closed Requests")
            sectionName  = NSLocalizedString("No Message History...", comment: "No Message History...")
        }
        */
        return "" //sectionName
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if tableView == tableUsers {
            return users.count
        }
        else if tableView == tableBusinessPartners {
            return businessPartners.count
        }
        else if tableView == tableVerificationType {
            return verificationTypes.count
        }
        else if tableView == tablePeerUsers {
            return users.count
        }
        else {
            return verificationStrategies.count
        }
    }
    
   
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //tableView.deselectRow(at: indexPath, animated: true)
        
        /*
        parentVC!.selectedVerification = filteredClosedProxVerifications[indexPath.row] as? Verifications.Closed.Verification
        parentVC!.performSegue(withIdentifier: "segueToViewDetails", sender: self)
        */
    }
    
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    */
    
    //should refactor this code... same code on dashboard
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tableUsers {
            let cell : UserCell = tableView.dequeueReusableCell(withIdentifier: "cellUser", for: indexPath) as! UserCell
            cell.labelName.text = users[indexPath.row]
              
            return cell
        }
        else if tableView == tableBusinessPartners {
            let cell : BusinessPartnerCell = tableView.dequeueReusableCell(withIdentifier: "cellBusinessPartner", for: indexPath) as! BusinessPartnerCell
            cell.labelName.text = businessPartners[indexPath.row]
           
            return cell
        }
        else if tableView == tableVerificationType{
            let cell : VerificationTypeCell = tableView.dequeueReusableCell(withIdentifier: "cellVerificationType", for: indexPath) as! VerificationTypeCell
            
            cell.labelType.text = verificationTypes[indexPath.row] as! String
           
            return cell
        }
        else if tableView == tablePeerUsers {
            let cell : UserCell = tableView.dequeueReusableCell(withIdentifier: "cellUser", for: indexPath) as! UserCell
            cell.labelName.text = users[indexPath.row]
              
            return cell
        }
        else {
            let cell : VerificationTypeCell = tableView.dequeueReusableCell(withIdentifier: "cellVerificationType", for: indexPath) as! VerificationTypeCell
            
            cell.labelType.text = verificationStrategies[indexPath.row] as! String
           
            return cell
        }
        /*
        let closedVerification : Verifications.Closed.Verification = filteredClosedProxVerifications[indexPath.row] as! Verifications.Closed.Verification

        return FeedCellHelper.buildShareCell(tableView: tableSecureMessages, indexPath: indexPath, closedVerification : closedVerification, accountId : closedVerification.AccountId)
        */
    }
    
    func getSortedBusinessPartnerNames() -> [String] {
        let partners = BizPartners.Local.getBizPartnersDictionary()
        var names : [String] = [String]()
        
        for (_, value) in partners {
            let partner : BizPartners.BizPartner = (value as? BizPartners.BizPartner)!
          
            if partner.Category != "Menu" {
                names.append(partner.Name)
            }
        }
        
        return names.sorted(by: <)
    }
    
    func getBusinessPartnerId(businessPartnerName : String) -> String {
        let partners = BizPartners.Local.getBizPartnersDictionary()
        
        for (_, value) in partners {
            let partner : BizPartners.BizPartner = (value as? BizPartners.BizPartner)!
          
            if partner.Name == businessPartnerName {
                return partner.Id
            }
        }
        
        return "none"
    }
    
    @objc func bizPartnersLoaded() {
        DispatchQueue.main.async {
            
            self.businessPartners = self.getSortedBusinessPartnerNames() //as! NSMutableArray // ["a", "b"]
            self.tableBusinessPartners.reloadData()
            
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableUsers.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            self.tableBusinessPartners.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            self.tableVerificationType.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            self.tableVerificationStrategy.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            self.tablePeerUsers.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            
            self.toggleActivityIndicatorView(title: "LOADING", show: false, withCompletion: {})
            
        }
    }
    
    
    @objc func userLoaded() {
        /*
        DispatchQueue.main.async {
            let user = User.Local.getUser(groupName: nil)
            
            let selectedBusinessPartnerIndexPath = self.tableBusinessPartners.indexPathForSelectedRow
            let currentBusinessPartnerCell = self.tableBusinessPartners.cellForRow(at: selectedBusinessPartnerIndexPath!) as! BusinessPartnerCell
            let businessPartnerName = currentBusinessPartnerCell.labelName?.text
            let businessPartnerId = self.getBusinessPartnerId(businessPartnerName: businessPartnerName!)
            
            if businessPartnerId != "none" {
                let businessPartnerCase : BizPartners.BusinessPartnerCase = BizPartners.BusinessPartnerCase()
                businessPartnerCase.CreatedTimestamp = TimeHelper.currentUTC()
                businessPartnerCase.PartnerId = businessPartnerId
                businessPartnerCase.Id = businessPartnerCase.CreatedTimestamp + "-" + businessPartnerCase.PartnerId
                businessPartnerCase.UserId = user.Id
                
                let selectedVerificationTypeIndexPath = self.tableVerificationType.indexPathForSelectedRow
                let currentVerificationTypeCell = self.tableVerificationType.cellForRow(at: selectedVerificationTypeIndexPath!) as! VerificationTypeCell
                let verificationTypeName = currentVerificationTypeCell.labelType?.text
                
                let selectedVerificationStrategyIndexPath = self.tableVerificationStrategy.indexPathForSelectedRow
                let currentVerificationStrategyCell = self.tableVerificationStrategy.cellForRow(at: selectedVerificationStrategyIndexPath!) as! VerificationTypeCell
                let verificationStrategy = currentVerificationStrategyCell.labelType?.text
                
                businessPartnerCase.VerificationType = verificationTypeName
                businessPartnerCase.VerificationStrategyType = verificationStrategy
                
                businessPartnerCase.Message = self.textViewMessage.text
                businessPartnerCase.AcceptCode = "accept123"
                businessPartnerCase.DeclineCode = "fail123"
                
                _ = BizPartners.saveBusinessCase(user: user, businessCase: businessPartnerCase)
            }
            //self.toggleActivityIndicatorView(title: "LOADING", show: false, withCompletion: {})
        }
         */
    }
    
    /*
    @objc func businessCaseRequestFinished() {
        DispatchQueue.main.async {
            self.toggleActivityIndicatorView(title: "SENDING", show: false, withCompletion: {})
            
            let finishedAlert = UIAlertController(title: "Business Partner Request",
                                                 message: "The request was sent Successfully." , preferredStyle: UIAlertController.Style.alert)
            
            finishedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
               
            }))
            
            self.present(finishedAlert, animated: true, completion: nil)
            //self.navigationController!.present(finishedAlert, animated: true, completion: nil)
        }
    }
    */
}


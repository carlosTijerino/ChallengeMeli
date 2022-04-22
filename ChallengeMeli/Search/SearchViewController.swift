//
//  SearchViewController.swift
//  ChallengeMeli
//
//  Created by Carlos Raymundo Tijerino Capetillo on 18/04/22.
//

import UIKit

//MARK: - MyDataSendingDelegateProtocol

protocol MyDataSendingDelegateProtocol {
    func sendDataToFirstViewController(myData: String)
}

//MARK: -

class SearchViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate {

    let service = Service()
    
    @IBOutlet weak var tableData: UITableView!
    
    var listSuggestions:[Suggestions] = [Suggestions]()
    var delegate: MyDataSendingDelegateProtocol?
    
    
    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
    }

    //MARK: -setUpUI
    
    func setUpUI(){
        
        tableData?.register(UINib.init(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
      
        tableData?.delegate = self
        tableData?.dataSource = self
        
        tableData?.backgroundColor = .white
        
        
        
    }
    
    //MARK: - getSuggestions
    
    func getSuggestions(query:String){
        
        let urlAPI = "\(Constants.apiMELI)\(Constants.domain_discovery)limit=4&q=\(query)"
        print("urlAPI \(urlAPI)")
        
        service.get_rest_api(requestType: "GET", url: urlAPI){ (response,error) in
            
            print("Response:\n \(response)")
            print("Error:\n \(error)")
                
            if(response != ""){
            
                self.parseJSON_suggestions(json: response)
                
            }
                
            else{
                
                if(!ConnectionManager.shared.hasConnectivity()){
                        
                    DispatchQueue.main.async {
                            
                        let errorResponse = "¡Parece que no hay internet!\nRevisa tu conexión para seguir navengando"
                        let alert = UIAlertController(title: "Alert", message: errorResponse, preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))

                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }

    //MARK: - parseJSON_suggestions
    
    func parseJSON_suggestions(json:String){
        
        let jsonData = Data(json.utf8)
        
        do {
            let respuestaWS = try! JSONDecoder().decode([Suggestions].self, from: jsonData)
                
            listSuggestions = respuestaWS
                
            DispatchQueue.main.async {
                if(self.listSuggestions.count > 0){
                    self.tableData.reloadData()
                }
            }
        }
    }
    
    //MARK: - tableView Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSuggestions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as? SearchTableViewCell
        
        if listSuggestions.count > 0 && indexPath.row < listSuggestions.count {
            cell?.lblSuggestion.text = listSuggestions[indexPath.row].domain_name
        }
        
        return cell!

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let textSearch = listSuggestions[indexPath.row].domain_name
        
        self.delegate?.sendDataToFirstViewController(myData: textSearch)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - updateSearchResults
    func updateSearchResults(for searchController: UISearchController) {
            
        searchController.searchBar.searchTextField.textColor = UIColor.black
        
        guard let text = searchController.searchBar.text else{
            return
        }
        
        if(text.count > 0){
            self.getSuggestions(query:text)
        }
        
    }
        
    
    //MARK: - searchBarCancelButtonClicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        
    }
    
    //MARK: - searchBarSearchButtonClicked
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let textSearch = searchBar.text ?? ""
        
        self.delegate?.sendDataToFirstViewController(myData: textSearch)
        self.dismiss(animated: true, completion: nil)
            
    }
    
}

//
//  ProductSearchListViewController.swift
//  ChallengeMeli
//
//  Created by Carlos Raymundo Tijerino Capetillo on 13/04/22.
//

import UIKit

//MARK: -

class ProductSearchListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate,MyDataSendingDelegateProtocol {
    
    let service = Service()
    let utilities = Utilities()
    
    @IBOutlet weak var myTableData: UITableView!
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var lblAlertNoProducts: UILabel!
    @IBOutlet weak var lblNumberProductsFound: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewNab: UIView!
    
    var listProducts:Array<Result> = Array<Result>()
    var listSuggestions:[Suggestions] = [Suggestions]()
    var pagingData:Paging = Paging()
    var searchController:UISearchController?
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Buscar Producto"
       
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchTableView") as! SearchViewController
        
        searchController = UISearchController(searchResultsController: vc)
        searchController?.searchResultsUpdater = vc
        searchController?.searchBar.delegate = vc
        searchController?.delegate = self
        searchController?.searchBar.returnKeyType = .done
        searchController?.isActive = true
        
        vc.delegate = self
        
        self.definesPresentationContext = true
        self.navigationItem.titleView = searchController?.searchBar

        searchController?.hidesNavigationBarDuringPresentation = false
        
        self.setUpUI()

    }
    
    //MARK: - setUpUI
    
    func setUpUI(){
        
        self.resultsView.layer.shadowColor = UIColor.gray.cgColor
        self.resultsView.layer.shadowOpacity = 1
        self.resultsView.layer.shadowOffset = .zero
        
        self.lblAlertNoProducts.text = "Utiliza el buscador para mostrar productos relacionados"
        self.lblAlertNoProducts.sizeToFit()
        
        myTableData.register(UINib.init(nibName: "ProductListTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductListTableViewCell")
      
        myTableData?.delegate = self
        myTableData?.dataSource = self
        
        myTableData?.backgroundColor = UIColor.white
       
        myTableData.reloadData()
    }
    
    //MARK: - showAlertNoProducts
    
    func showAlertNoProducts(){
        
        if(listProducts.count == 0){
            lblAlertNoProducts.text = "No se encontraron resultados"
            lblAlertNoProducts.isHidden = false
            
        }
        
        else{
            lblAlertNoProducts.isHidden = true
        }
    }
    
    //MARK: - setNumberProductsFound
    
    func setNumberProductsFound(){
       
        var total:Double = 0
        
        if(self.pagingData.total != nil){
            total = Double(self.pagingData.total!)
            
        }
        
        let totalVal = utilities.formatString(amount: total)
        
        lblNumberProductsFound.text = "\(totalVal) Resultados"
    }
    
    //MARK: - searchProduct
    
    func searchProduct(productSearch:String){
        
        let urlAPI = "\(Constants.apiMELI)\(Constants.searchItems)\(productSearch)&limit=20"
        print("urlAPI \(urlAPI)")
        
        self.lblAlertNoProducts.isHidden = true
        self.activityIndicator.startAnimating()
        
        service.get_rest_api(requestType: "GET", url: urlAPI){ (response,error) in
            
            print("Response:\n \(response)")
            print("Error:\n \(error)")
                
            if(response != ""){
            
                DispatchQueue.global(qos: .default).sync {
                    self.parseJSON(json: response)
                }
            }
                
            else{
                
                if(!ConnectionManager.shared.hasConnectivity()){
                        
                    DispatchQueue.main.async {
                            
                        self.activityIndicator.stopAnimating()
                        
                        let errorResponse = "¡Parece que no hay internet!\nRevisa tu conexión para seguir navengando"
                        let alert = UIAlertController(title: "Alert", message: errorResponse, preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))

                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    //MARK: - parseJSON
    
    func parseJSON(json:String){
        
        let jsonData = Data(json.utf8)
        
        do {
            let respuestaWS = try! JSONDecoder().decode(Search.self, from: jsonData)
            
            
            if(respuestaWS.paging != nil){
                pagingData = respuestaWS.paging!
                
                if(respuestaWS.results != nil){
                    listProducts = respuestaWS.results!
                    
                    DispatchQueue.main.async {
                        self.showAlertNoProducts()
                        self.setNumberProductsFound()
                        self.myTableData.reloadData()
                        self.activityIndicator.stopAnimating()
                            
                    }
                }
            }
            
            else{
                
                var message:String = ""
                var error:String = ""
                
                message = respuestaWS.message != nil ? respuestaWS.message! : ""
                error   = respuestaWS.error   != nil ? respuestaWS.error!   : ""
                
                print("Mensaje ====> \(String(describing: message))")
                print("Error ====> \(String(describing: error))")
                    
                DispatchQueue.main.async {
                    
                    self.activityIndicator.stopAnimating()
                
                    let errorResponse = "A ocurrido un error al obtener la información del servidor"
                    let alert = UIAlertController(title: "Alert", message: errorResponse, preferredStyle: .alert)
                
                    alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))

                    self.present(alert, animated: true)
                }
            }
        }
    }
   
    //MARK: - tableView Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listProducts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListTableViewCell") as? ProductListTableViewCell
        
        cell?.productName.text = listProducts[indexPath.row].title
        
        var amount:Double = 0
        
        if(listProducts[indexPath.row].price != nil){
            amount = listProducts[indexPath.row].price!
            
        }
        
        let price = utilities.formatString(amount: amount)
        
        cell?.productPrice.text = "$\(price)"
        
        let imgProduct = listProducts[indexPath.row].thumbnail
        
        var https:String = ""
        
        if(imgProduct != nil){
            https = "https" + imgProduct!.dropFirst(4)
        }
        
        let url = URL(string: https)
        
        if(url != nil){
            if let data = try? Data(contentsOf: url!) {
                cell?.ivProduct.image = UIImage(data: data)
            }
        }
        
        return cell!

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "ProductDetail") as! ProductDetailViewController
            detailVC.productData = listProducts[indexPath.row]
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
  
    
    //MARK: - sendDataToFirstViewController
    
    func sendDataToFirstViewController(myData: String) {
        searchController?.searchBar.text = myData
        self.searchProduct(productSearch:myData)
    }
    
    //MARK: -
}

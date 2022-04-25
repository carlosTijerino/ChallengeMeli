//
//  ProductDetailViewController.swift
//  ChallengeMeli
//
//  Created by Carlos Raymundo Tijerino Capetillo on 13/04/22.
//

import UIKit

class ProductDetailViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate {

    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var viewProduct: UIView!
    @IBOutlet weak var viewProductDetail: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var lblStock: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var tableItems: UITableView!
    @IBOutlet weak var viewStock: UIView!
    @IBOutlet weak var tableItemsSeller: UITableView!
    @IBOutlet weak var tableProductInfo: UITableView!
    @IBOutlet weak var lblNotResultsFound: UILabel!
    @IBOutlet weak var carousel: UIScrollView!
    @IBOutlet weak var lblCountImages: UILabel!
    @IBOutlet weak var ContentViewCarousel: UIView!
    @IBOutlet weak var contraintHeigthTable: NSLayoutConstraint!
    
    var descriptionValue:String? = ""
    var location:String = ""
    var countImages:Int = 0
    var productData:Result = Result()
    var attributes:Array<Attribute> = Array<Attribute>()
    var listProductsSeller:Array<Result> = Array<Result>()
    var arrayPictures:Array<Picture> = Array<Picture>()
    
    let service = Service()
    let utilities = Utilities()
    
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBar()
        self.setUpUI()
        self.getImages()
        self.getDescription()
        self.getSellersItems()
    
    }
    
    
    
    //MARK: -setNavigationBar
    
    func setNavigationBar(){
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    //MARK: -setUpUI
    
    func setUpUI(){
        
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        }
        
        else {
            activityIndicator.style = .gray
        }
        
        carousel.delegate = self
        
        lblProductName.text = productData.title
        
        if(productData.price != nil){
            
            var amount:Double = 0
                amount = productData.price!
            
            let price = utilities.formatString(amount: amount)
            
            lblPrice.text = "$\(price)"
        }
        
        if(productData.available_quantity != nil){
            
            var amount:Double = 0
                amount = Double(productData.available_quantity!)
            
            let stock = utilities.formatString(amount: amount)
            
            lblStock.text = "Cantidad:1 (\(stock) disponibles)"
        }
        
        if(productData.seller_address != nil){
            if(productData.seller_address!.country != nil){
                if(productData.seller_address!.country!.name != nil){
                    location += "\(productData.seller_address!.country!.name!), "
                }
            }
            
            if(productData.seller_address!.state != nil){
                if(productData.seller_address!.state!.name != nil){
                    location += "\(productData.seller_address!.state!.name!)"
                }
            }
            
            lblLocation.text = location
        }
        
        if(productData.attributes != nil){
            attributes = productData.attributes!
            
            let itemCondition = attributes.firstIndex(where: {$0.id == "ITEM_CONDITION"})
            
            if(itemCondition != nil){
                let condition = attributes[itemCondition!].value_name
                
                lblCondition?.layer.cornerRadius = 5
                lblCondition?.layer.masksToBounds = true
            
                if(condition != nil){
                    lblCondition.text = " \(String(describing: condition!)) "
                }
            }
        }
        
        self.viewStock.layer.cornerRadius = 10
        self.viewStock.layer.borderWidth = 2
        self.viewStock.layer.borderColor = UIColor.white.cgColor
        
        tableProductInfo.register(UINib.init(nibName: "ProductInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductInfoTableViewCell")
      
        tableProductInfo?.delegate = self
        tableProductInfo?.dataSource = self
        tableProductInfo?.tag = 2
        tableProductInfo?.backgroundColor = UIColor.white
        tableProductInfo.reloadData()
        
        tableItemsSeller.register(UINib.init(nibName: "ProductListTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductListTableViewCell")
      
        tableItemsSeller?.delegate = self
        tableItemsSeller?.dataSource = self
        tableItemsSeller?.tag = 1
        tableItemsSeller?.backgroundColor = UIColor.white
        tableItemsSeller.reloadData()
        
        lblCountImages?.layer.cornerRadius = 8
        lblCountImages?.layer.masksToBounds = true
        
    }
    
    //MARK: -createScrollImages
    
    func createScrollImages(){
        
        self.ContentViewCarousel.removeFromSuperview()
        
        countImages = arrayPictures.count >= 10 ? 5 : arrayPictures.count

        for i in 0..<countImages {
           
            let imageView = UIImageView()
            
            let x = self.carousel.frame.size.width * CGFloat(i)
            imageView.frame = CGRect(x: x, y: 0, width: self.carousel.frame.width, height: self.carousel.frame.height)
                
            imageView.contentMode = .scaleAspectFit
            
            if(arrayPictures[i].secure_url != nil){
                let imgProduct = arrayPictures[i].secure_url!
                
                let url = URL(string: imgProduct)
                
                if(url != nil){
                    if let data = try? Data(contentsOf: url!) {
                        imageView.image = UIImage(data: data)
                    }
                }
            }
            
            carousel.contentSize.width = carousel.frame.size.width * CGFloat(i + 1)
            carousel.addSubview(imageView)
            
            lblCountImages.text = " 1/\(countImages) "
        }
    }
    
    //MARK: - showAlertNoProducts
    
    func showAlertNoProducts(){
        
        if(listProductsSeller.count == 0){
            lblNotResultsFound.isHidden = false
        }
        
        else{
            lblNotResultsFound.isHidden = true
        }
    }
    
    //MARK: -getImages
    
    func getImages(){
            
        let idProduct:String = productData.id!
        
        let urlAPI = "\(Constants.apiMELI)\(Constants.items)\(idProduct)"
        print("urlAPI \(urlAPI)")
            
        self.activityIndicator.startAnimating()
        
        service.get_rest_api(requestType: "GET", url: urlAPI){ (response,error) in
                
            print("Response:\n \(response)")
            print("Error:\n \(error)")
            
            if(response != ""){
            
                DispatchQueue.global(qos: .default).sync {
                    self.parseJSON_getImages(json: response)
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
    
    
    //MARK: -getDescription
    
    func getDescription(){
            
        let idProduct:String = productData.id!
        
        let urlAPI = "\(Constants.apiMELI)\(Constants.items)\(idProduct)/description"
        print("urlAPI \(urlAPI)")
            
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
    
    //MARK: -getSellersItems
    
    func getSellersItems(){
            
        let sellerId:Int = (productData.seller?.id!)!
        
        let urlAPI = "\(Constants.apiMELI)\(Constants.searchItemsSeller)\(sellerId)&limit=2"
        print("urlAPI \(urlAPI)")
            
        self.activityIndicator.startAnimating()
        
        service.get_rest_api(requestType: "GET", url: urlAPI){ (response,error) in
                
            print("Response:\n \(response)")
            print("Error:\n \(error)")
            
            if(response != ""){
            
                DispatchQueue.global(qos: .default).sync {
                    self.parseJSON_sellerItems(json: response)
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
    
    //MARK: -parseJSON
    
    func parseJSON(json:String){
        
        let jsonData = Data(json.utf8)
        
        do {
            let respuestaWS = try! JSONDecoder().decode(Description.self, from: jsonData)
            
            
            if(respuestaWS.plain_text != nil){
                self.descriptionValue = respuestaWS.plain_text!
                
                    DispatchQueue.main.async {
                        self.tvDescription.text = self.descriptionValue!
                        self.activityIndicator.stopAnimating()
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
    
    //MARK: -parseJSON_sellerItems
    
    func parseJSON_sellerItems(json:String){
        
        let jsonData = Data(json.utf8)
        
        do {
            let respuestaWS = try! JSONDecoder().decode(ItemsSeller.self, from: jsonData)
            
            
            if(respuestaWS.results != nil){
                
                listProductsSeller = respuestaWS.results!
                
                DispatchQueue.main.async {
                
                    self.showAlertNoProducts()
                    self.tableItemsSeller.reloadData()
                    self.activityIndicator.stopAnimating()
                            
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

    //MARK: -parseJSON_getImages
    
    func parseJSON_getImages(json:String){
        
        let jsonData = Data(json.utf8)
        
        do {
            let respuestaWS = try! JSONDecoder().decode(Pictures.self, from: jsonData)
            
            
            if(respuestaWS.pictures != nil){
                
                arrayPictures = respuestaWS.pictures!
                
                DispatchQueue.main.async {
                
                    self.createScrollImages()
                    self.activityIndicator.stopAnimating()
                            
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
        
        if(tableView.tag == 1){
            return listProductsSeller.count
        }
        
        return attributes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(tableView.tag == 1){
            return 100
        }
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView.tag == 1){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListTableViewCell") as? ProductListTableViewCell
            
            cell?.productName.text = listProductsSeller[indexPath.row].title
            
            var amount:Double = 0
            
            if(listProductsSeller[indexPath.row].price != nil){
                amount = listProductsSeller[indexPath.row].price!
                
            }
            
            let price = utilities.formatString(amount: amount)
            
            cell?.productPrice.text = "$\(price)"
            
            
            let imgProduct = listProductsSeller[indexPath.row].thumbnail
            
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
        
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductInfoTableViewCell") as? ProductInfoTableViewCell
        
            cell?.lblAttributeName.text = attributes[indexPath.row].name
            cell?.lblAttributeValue.text = attributes[indexPath.row].value_name
        
            if(indexPath.row % 2 == 0){
                if #available(iOS 11.0, *) {
                    cell!.viewAttributeName.backgroundColor = UIColor.init(named: "AttributeNameColor")
                    cell!.viewAttributeValue.backgroundColor = UIColor.init(named: "AttributeValueColor")
                } else {
                    cell!.viewAttributeName.backgroundColor = UIColor(red: 176/255.0, green: 176/255.0, blue: 176/255.0, alpha: 1.0)
                    cell!.viewAttributeValue.backgroundColor = UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1.0)
                    
                }
                
            }
        
            else{
                
                if #available(iOS 11.0, *) {
                    cell!.viewAttributeName.backgroundColor = UIColor.init(named: "AttributeNameColor2")
                    cell!.viewAttributeValue.backgroundColor = UIColor.init(named: "AttributeValueColor2")
                } else {
                    cell!.viewAttributeName.backgroundColor = UIColor(red: 209/255.0, green: 209/255.0, blue: 209/255.0, alpha: 1.0)
                    cell!.viewAttributeValue.backgroundColor = UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1.0)
                    
                }
                
                
            }
            
            DispatchQueue.main.async {
                
                self.contraintHeigthTable.constant = self.tableProductInfo.contentSize.height
                
            }
            
           
            return cell!

        }
    }
    
    //MARK: - scrollViewDidScroll
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width) + 1
        lblCountImages.text = " \(Int(pageIndex))/\(countImages) "
    }
}

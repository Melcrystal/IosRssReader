//
//  TableViewController.swift
//  Reader
//
//  Created by Admin on 30/01/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, XMLParserDelegate {
    var films: [Film] = []
    var eName: String = ""
    var filmName = ""
    var filmDescription = ""
    var urlImage = ""
    var date = ""
    var itemTrue: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path:String = "http://rss.allocine.fr/ac/cine/cettesemaine"
        let urlToSend: URL = URL(string: path)!
        if let parser = XMLParser(contentsOf: urlToSend) {
            parser.delegate = self
            parser.parse()
            

        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return films.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sortie", for: indexPath)
        
        let film = films[indexPath.row]
        
        if let cellLabel = cell.viewWithTag(1) as? UIWebView {
            
            cellLabel.loadHTMLString(film.filmDescription, baseURL: nil)
        }
        if let cellLabel = cell.viewWithTag(2) as? UILabel {
            
            cellLabel.text = film.filmTitle
        }
        if let cellLabel = cell.viewWithTag(4) as? UILabel {
            
            cellLabel.text = film.datePost
        }
        if let cellLabel = cell.viewWithTag(3) as? UIImageView {
            let url = URL(string: film.image)
            let data = try? Data(contentsOf: url!)
            
            cellLabel.image = UIImage(data: data!)
        }
        
        return cell
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        eName = elementName;
        if elementName == "item" {
           // itemTrue = true
            filmName = String()
            filmDescription = String()
            urlImage = String()
            date = String()
        } else if elementName == "enclosure"{
            if let c = attributeDict["url"] {
                urlImage = c
            }
            
        }
    }
    // 2
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        eName="";
        if elementName == "item"{
            
            let film = Film()
            film.filmTitle = filmName
            film.filmDescription = filmDescription
            film.image = urlImage
            film.datePost = date
           // itemTrue = false
            films.append(film)
        }
    }
    
    // 3
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespaces)
        if (!data.isEmpty) {
            if eName == "title" {
                filmName += data
            } else if eName == "description" {
                filmDescription += data
            } else if eName == "pubDate" {//&& itemTrue == true{
                date += data
            }
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

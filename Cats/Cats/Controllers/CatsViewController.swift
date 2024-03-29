//
//  CatsViewController.swift
//  Cats
//
//  Created by Egor Tereshonok on 11/12/19.
//  Copyright © 2019 Egor Tereshonok. All rights reserved.
//

import UIKit

class CatsViewController: UIViewController {
    
    private var cats = [Cats]()
    private var catName: String?
    private var catImageURLT: String?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        
    }
    
    
    func fetchData() {
        
        let jsonUrlString = "https://api.myjson.com/bins/6cc0e"
        
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                self.cats = try JSONDecoder().decode([Cats].self, from: data)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print("Error serialization json", error)
            }
            
        }.resume()
    }
    
    private func configureCell(cell: TableViewCell, for indexPath: IndexPath) {
        
        let cat = cats[indexPath.row]
        cell.catTitle.text = cat.title ?? ""
        
        if let id = cat.id{
            cell.id.text = "id: \(id)"
        }
        
        cell.catDiscription.text = cat.description ?? ""
        
        DispatchQueue.global().async {
            guard let imageUrl = URL(string: cat.imageUrl!) else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            
            DispatchQueue.main.async {
                cell.catImage.image = UIImage(data: imageData)
            }
        }
        
    }
    //MARK: Navigation 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
            backItem.title = "table"
        self.navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    
         if segue.identifier == "Description" {
             if let indexPath = self.tableView.indexPathForSelectedRow {
                 let cat = cats[indexPath.row]
                 let imageVC = segue.destination as! ImageViewController
                 if let url = cat.imageUrl {
                     imageVC.viewImageUrl = url
                 }
             }
         }
     }
    
}
// MARK: Table View Data Source

extension CatsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        configureCell(cell: cell, for: indexPath)
        
        return cell
    }
}

// MARK: Table View Delegate

extension CatsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
   
}


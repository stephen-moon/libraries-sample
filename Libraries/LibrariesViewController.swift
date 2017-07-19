//
//  LibrariesViewController.swift
//  Libraries
//
//  Created by Stephen Moon on 2017-07-12.
//  Copyright © 2017 stephendmoon. All rights reserved.
//

import UIKit

class LibrariesViewController: UITableViewController {
    
    var libraries: Array<Any> = []
    var selectedLibraryInfo: Dictionary<String, Any> = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prepare activity indicator and show
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()

        // Retrieve list of libraries
        let urlString = "https://data.cityofchicago.org/resource/x8fc-8rcq.json"
        let url = URL(string: urlString)
        let urlRequest = URLRequest(url: url!)
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 5.0
        let session = URLSession(configuration: sessionConfig)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            // Stop activity indicator
            activityIndicator.stopAnimating()
            
            if error != nil {
                self.showAlert("Error", message: (error?.localizedDescription)!)
            }
            else {
                let httpResponse = response as? HTTPURLResponse
                if (httpResponse?.statusCode == 200) && (data != nil) {
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: data!, options: []) as? [Any]
                        self.libraries = jsonObject!
                        self.tableView.reloadData()
                    }
                    catch {
                        self.showAlert("Error", message: "Json parse error")
                    }
                }
                else {
                    self.showAlert("Error", message: "Wrong response or null data")
                }
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libraries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "libraryTitleCell", for: indexPath)

        let libraryInfo = libraries[indexPath.row] as! [String: AnyObject]
        cell.textLabel?.text = libraryInfo["name_"] as? String

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLibraryInfo = libraries[indexPath.row] as! Dictionary<String, Any>
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "showLibraryInfo", sender: nil)
    }

    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Set title of back button
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showLibraryInfo" {
            let detailsVC = segue.destination as! LibraryDetailsViewController
            detailsVC.libraryInfo = selectedLibraryInfo
        }
    }
}

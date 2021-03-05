//
//  ShoppingTableViewController.swift
//  ShoppingList
//
//  Created by 廖昱晴 on 2021/3/4.
//

import UIKit

typealias AddItemClosure = (Bool, String?) -> ()

class ShoppingTableViewController: UITableViewController {

    var shoppingItem = [String]() //初始化陣列
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadList()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shoppingItem.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = shoppingItem[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        popUpAlert(shoppingItem[indexPath.row]) { (success, result) in
            if success == true {
                if let okResult = result{
                    self.shoppingItem[indexPath.row] = okResult
                    self.tableView.reloadData()
                    self.saveList()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shoppingItem.remove(at: indexPath.row)
            saveList()
            tableView.reloadData()
        }
    }
    
    func popUpAlert(_ value: String?, withConpletionHandler handler: @escaping AddItemClosure) { //@escaping: 執行closure的時機為函式完成後，此例為按下OK或Cancel按鈕之後才開始執行
        let alert = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Add New Item Here" //提示文字
            textField.text = value
        }
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in //按下OK按鈕要做的事情
            if let inputText = alert.textFields?[0].text { //拿取文字輸入框內的文字
                if inputText != "" {
                    handler(true, inputText)
                } else {
                    handler(false, nil)
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action) in //按下Cancel按鈕要做的事情
            handler(false, nil)
        })
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func saveList() {
        UserDefaults.standard.setValue(shoppingItem, forKey: "shoppingItem")
    }
    
    func loadList() {
        if let list = UserDefaults.standard.stringArray(forKey: "shoppingItem") {
            shoppingItem = list
        }
    }
    

    @IBAction func addItem(_ sender: UIBarButtonItem) {
        popUpAlert(nil) { (success, result) in
            if success == true {
                if let okResult = result{
                    self.shoppingItem.append(okResult)
                    let insertItem = IndexPath(row: self.shoppingItem.count - 1, section: 0) //插入的列數和section
                    self.tableView.insertRows(at: [insertItem], with: .left) //tableView插入新的列表，left從左插入資料
                    self.saveList()
                }
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

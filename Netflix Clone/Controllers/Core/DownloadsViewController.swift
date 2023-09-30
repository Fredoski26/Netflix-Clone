//
//  DownloadsViewController.swift
//  Netflix Clone
//
//  Created by Fredrick on 28/08/2023.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    
    
    private var titles: [TitleItem] = [TitleItem]()
    private let downloadTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        title = "Download"
        view.addSubview(downloadTable)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.largeTitleDisplayMode = .always
        downloadTable.dataSource = self
        downloadTable.delegate = self
        fetchlocalStorageForDownload()
        
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil){
            _ in self.fetchlocalStorageForDownload()
        }

    }
    

    private  func fetchlocalStorageForDownload(){
        DatapersistenceManager.share.fetchingTitleFromDatabase {[weak self] result in switch result {
        case .success(let titles):
            self?.titles = titles
            DispatchQueue.main.async{
                self?.downloadTable.reloadData()

            }
        case .failure(let error):
            print(error.localizedDescription)
        } }
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTable.frame = view.bounds
    }
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = titles[indexPath.row].original_name ?? titles[indexPath.row].original_title ?? "unknown"
//
//        return cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as?  TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: (title.original_title ?? title.original_name) ?? "Unknown title name", posterURL: title.poster_path ?? ""))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        switch editingStyle{
            
        case .delete:
            DatapersistenceManager.share.deleteTitleWith(model: titles[indexPath.row]){ [weak self]
                result in switch result {
                case .success():
                    
                    // create the alert
                    let alert = UIAlertController(title: "Deletion", message: "Successfully deleted.", preferredStyle: UIAlertController.Style.alert)

                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                    // show the alert
                    self!.present(alert, animated: true, completion: nil)
                    print("Deleted")
                    DispatchQueue.main.async{
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.titles.remove(at: indexPath.row)

                tableView.deleteRows(at: [indexPath], with: .fade)

            }
        default:
            break
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        
        ApiCaller.shared.getMovie(with: titleName){[weak self] results in
            switch results {
            case.success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                      vc.configure(with: TitlePreviewViewModel(title: titleName, youubeview: videoElement, titleOverview: title.overview ?? ""))
                      self?.navigationController?.pushViewController(vc, animated: true)
                }
              
        case.failure(let error):
            print(error.localizedDescription)
        }
            
        }
    }
}

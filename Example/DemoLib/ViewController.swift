import UIKit
import DemoLib

struct Character: Decodable {
    let identifier: Int
    let name: String
    let status: String
    let species: String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case status
        case species
        case image
    }
}

class ViewController: UIViewController {

    var table = UITableView()
    var charactersArray: [Character] = [Character(identifier: 0, name: "Placeholder text", status: "Placeholder text", species: "Placeholder text", image: "Placeholder text")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(Cell.self, forCellReuseIdentifier: "1")
        
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        table.dataSource = self
        table.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charactersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "1") as! Cell
        let cellContent = charactersArray[indexPath.row]
        cell.prepare()
        cell.setCellValues(name: cellContent.name, species: cellContent.species, status: cellContent.status, image: cellContent.image)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

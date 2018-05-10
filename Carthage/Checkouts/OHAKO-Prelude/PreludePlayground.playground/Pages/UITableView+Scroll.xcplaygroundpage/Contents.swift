//: [Previous](@previous)
/*:
 # UITableView+Scroll
 */
import UIKit
import XCPlayground
import PlaygroundSupport
import Prelude

/*:
 ## scrollToBottom(animated: Bool)
 */

class ViewController: UIViewController {
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView = UITableView(frame: view.frame)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(self.tableView)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = "\(indexPath.row): tap to scroll bottom"
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.scrollToBottom(animated: true)
    }
}
PlaygroundPage.current.liveView = ViewController()

//: [Next](@next)

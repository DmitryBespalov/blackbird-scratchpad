//
//  GuardianTableViewCell.swift
//  DisApp
//
//  Created by Dmitry Bespalov on 23.12.22.
//

import UIKit

class GuardianTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ens: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var reason: UILabel!
    @IBOutlet weak var contributionCaption: UILabel!
    @IBOutlet weak var contribution: UILabel!

    var item: Guardian? {
        didSet {
            updateContent()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateContent()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateContent() {
        guard let item = item else {
            for label in [name, ens, address, reason, contributionCaption, contribution] {
                label?.text = nil
            }
            return
        }

        name.text = item.name
        ens.text = item.ens
        address.text = item.address
        reason.text = item.reason
        contribution.text = item.contribution
    }
    
}

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
    @IBOutlet weak var reasonCaption: UILabel!
    @IBOutlet weak var reason: UITextView!
    @IBOutlet weak var contributionCaption: UILabel!
    @IBOutlet weak var contribution: UITextView!

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
            for label in [name, ens, address, reasonCaption, contributionCaption] {
                label?.text = nil
            }
            for textView in [reason, contribution] {
                textView?.text = nil
            }
            return
        }

        name.text = item.name
        ens.text = item.ens
        address.text = item.address
        reasonCaption.text = "Reason to be a delegate"
        reason.text = item.reason
        contributionCaption.text = "Contributions"
        contribution.text = item.contribution
        contribution.sizeToFit()
    }
    
}

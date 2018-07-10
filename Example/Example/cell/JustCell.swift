//
//  JustCell.swift
//  Example
//
//  Created by Roman Kotov on 10/07/2018.
//  Copyright © 2018 Roman Kotov. All rights reserved.
//

import UIKit
import RKTableAdapter

class JustCell: UITableViewCell, ConfigurableCell {
    typealias ViewModelType = JustCellVM

    // MARK: - Properties
    var viewModel: ViewModelType?

    // MARK: - UI

    // MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

    }

    // MARK: - Configure
    private func configure() {

    }

    // MARK: - ConfigurableCell
    func configure(with viewModel: ViewModelType) {
        self.textLabel?.text = viewModel.title
    }

    // MARK: - Actions
}

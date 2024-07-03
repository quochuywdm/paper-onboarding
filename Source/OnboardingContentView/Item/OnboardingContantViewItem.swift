//
//  OnboardingContentViewItem.swift
//  AnimatedPageView
//
//  Created by Alex K. on 21/04/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

open class OnboardingContentViewItem: UIView {

    open var imageView: UIImageView?
    open var titleLabel: UILabel?
    open var descriptionLabel: UILabel?
    
    var stackView: UIStackView!
    
    public static let topPadding: CGFloat = 50
    public static let bottomPadding: CGFloat = 20
    public static let leftRightPadding: CGFloat = 20
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Common init
    func commonInit() {
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: OnboardingContentViewItem.leftRightPadding),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -OnboardingContentViewItem.leftRightPadding),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: OnboardingContentViewItem.topPadding),
            stackView.bottomAnchor.constraint(greaterThanOrEqualTo: self.bottomAnchor, constant: OnboardingContentViewItem.bottomPadding),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        
        imageView = createImage()
        titleLabel = createTitleLabel()
        descriptionLabel = createDescriptionLabel()

        if let imageView = imageView, let titleLabel = titleLabel, let descriptionLabel = descriptionLabel {
            stackView.addArrangedSubview(imageView)
            stackView.addArrangedSubview(titleLabel)
            stackView.addArrangedSubview(descriptionLabel)
        }
    }
}

// MARK: create

private extension OnboardingContentViewItem {

    func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "Nunito-Bold", size: 36)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        return label
    }

    func createDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Regular", size: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        return label
    }

    func createImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }
}

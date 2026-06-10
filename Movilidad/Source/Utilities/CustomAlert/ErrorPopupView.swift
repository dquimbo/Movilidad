//
//  ErrorPopupView.swift
//  Movilidad
//
//  Created by Diego Quimbo on 10/6/26.
//

import UIKit

final class ErrorPopupView: UIView {

    // MARK: - Callbacks
    private let onSeeDetails: (() -> Void)?

    // MARK: - UI
    private let dimmedBackground = UIView()
    private let cardView = UIView()
    private let closeButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let buttonsStack = UIStackView()
    private let detailButton = UIButton(type: .system)
    private let acceptButton = UIButton(type: .system)

    // MARK: - Lifecycle
    required init(title: String, message: String, onSeeDetails: (() -> Void)? = nil) {
        self.onSeeDetails = onSeeDetails

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        setupView()

        titleLabel.text = title
        descriptionLabel.text = message
        detailButton.isHidden = onSeeDetails == nil
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions
    func present(over parent: UIView) {
        parent.addSubview(self)

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parent.topAnchor),
            bottomAnchor.constraint(equalTo: parent.bottomAnchor),
            leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            trailingAnchor.constraint(equalTo: parent.trailingAnchor)
        ])

        alpha = 0
        cardView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)

        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
            self.cardView.transform = .identity
        }
    }
}

// MARK: - Actions
private extension ErrorPopupView {
    @objc func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }

    @objc func seeDetailsPressed() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
            self.onSeeDetails?()
        })
    }
}

// MARK: - Setup
private extension ErrorPopupView {
    func setupView() {
        setupDimmedBackground()
        setupCard()
        setupCloseButton()
        setupLabels()
        setupButtons()
        setupContentLayout()
    }

    func setupDimmedBackground() {
        dimmedBackground.backgroundColor = UIColor(white: 0, alpha: 0.45)
        dimmedBackground.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dimmedBackground)

        NSLayoutConstraint.activate([
            dimmedBackground.topAnchor.constraint(equalTo: topAnchor),
            dimmedBackground.bottomAnchor.constraint(equalTo: bottomAnchor),
            dimmedBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            dimmedBackground.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        dimmedBackground.addGestureRecognizer(tap)
    }

    func setupCard() {
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 14
        cardView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cardView)

        let preferredWidth = cardView.widthAnchor.constraint(equalToConstant: 320)
        preferredWidth.priority = .defaultHigh

        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cardView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 24),
            cardView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -24),
            cardView.widthAnchor.constraint(lessThanOrEqualToConstant: 340),
            preferredWidth
        ])
    }

    func setupCloseButton() {
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = Asset.labelMenuItems.color
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        cardView.addSubview(closeButton)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    func setupLabels() {
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = Asset.labelText.color
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        descriptionLabel.font = .systemFont(ofSize: 15)
        descriptionLabel.textColor = Asset.labelMenuItems.color
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
    }

    func setupButtons() {
        acceptButton.setTitle(L10n.General.accept, for: .normal)
        acceptButton.setTitleColor(.white, for: .normal)
        acceptButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        acceptButton.backgroundColor = Asset.buttonBackground.color
        acceptButton.layer.cornerRadius = 8
        acceptButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)

        detailButton.setTitle("Ver detalle", for: .normal)
        detailButton.setTitleColor(Asset.buttonBackground.color, for: .normal)
        detailButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        detailButton.backgroundColor = .clear
        detailButton.layer.cornerRadius = 8
        detailButton.layer.borderWidth = 1
        detailButton.layer.borderColor = Asset.buttonBackground.color.cgColor
        detailButton.addTarget(self, action: #selector(seeDetailsPressed), for: .touchUpInside)

        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 12
        buttonsStack.distribution = .fillEqually
        buttonsStack.addArrangedSubview(detailButton)
        buttonsStack.addArrangedSubview(acceptButton)
    }

    func setupContentLayout() {
        let contentStack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, buttonsStack])
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.setCustomSpacing(24, after: descriptionLabel)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 28),
            contentStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
            buttonsStack.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

// MARK: - Presentation helper
extension UIViewController {
    func showErrorPopup(title: String = L10n.General.Error.title,
                        message: String,
                        serviceError: ServiceError? = nil) {
        let onSeeDetails: (() -> Void)?

        if let serviceError = serviceError {
            onSeeDetails = { [weak self] in
                guard let self = self else { return }
                let detail = ServiceErrorDetailBuilder.build(serviceError: serviceError)
                self.present(detail, animated: true)
            }
        } else {
            onSeeDetails = nil
        }

        let popup = ErrorPopupView(title: title, message: message, onSeeDetails: onSeeDetails)
        popup.present(over: view)
    }
}

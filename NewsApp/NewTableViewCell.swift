//
//  NewTableViewCell.swift
//  NewsApp
//
//  Created by Deep Chaturvedi on 5/18/22.
//

import UIKit

class NewTableViewCellViewModel {
    let title:String
    let subTitle:String
    let image:URL?
    var imageData:Data?
    var publised:String?
    
    
    init(title:String,subTitle:String,image:URL?,publised:String?) {
        self.title = title
        self.subTitle = subTitle
        self.image = image
        self.publised = publised
    }
}

class NewTableViewCell: UITableViewCell {
    static let identifier = "NewTableViewCell"
    
    private let newsTitleLabel:UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 23, weight: .medium)
        return label
    }()
    
    private let subTitleLabel:UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private let newsImageView:UIImageView = {
       let  imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
        
    }()
    private let newsPublished:UILabel = {
       let  datePublished = UILabel()
        datePublished.numberOfLines = 0
        datePublished.font = .systemFont(ofSize: 14, weight: .semibold)
        return datePublished
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(newsImageView)
        contentView.addSubview(newsPublished)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        newsPublished.frame = CGRect(x: 10, y: 200, width: contentView.frame.size.width, height: 60)

        newsTitleLabel.frame = CGRect(x: 10, y: 250, width: contentView.frame.size.width, height: 60)
        
        subTitleLabel.frame = CGRect(x: 10, y: 300, width:contentView.frame.size.width, height: 60)
        
        newsImageView.frame = CGRect(x: 0, y: 5, width: contentView.frame.size.width, height: 200)

    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with viewModel:NewTableViewCellViewModel) {
        newsTitleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.subTitle
        newsPublished.text = viewModel.publised?.getFormattedDate()
        
     //image
        if let data = viewModel.imageData{
            newsImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.image{
            URLSession.shared.dataTask(with: url) {[weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)

                }
            }.resume()
        }
    }
    
}

extension String {
    func getFormattedDate() -> String{
        let dateString = self
        let formattor = ISO8601DateFormatter()
        guard let dateValue = formattor.date(from: dateString) else { return "" }
        guard let currentDateComponent = Calendar.current.dateComponents([.day], from: Date()).day else { return ""}
        guard let publishedDateComponent = Calendar.current.dateComponents([.day], from: dateValue).day else { return ""}
        switch (currentDateComponent - publishedDateComponent) {
        case 0:
            return "Today"
        case 1:
            return "1 Day Before"
        case 2:
            return "2 Day Before"
        case 3:
            return "3 Day Before"
        case 4:
            return "4 Day Before"
        case 5:
            return "5 Day Before"
        case 6:
            return "6 Day Before"
        case 7...14:
            return "Few Week ago"
        case 30...60:
            return "Few Month Ago"
        default:
            return "1 Year ago."
        }
    }
}

//
//  ColorDict.swift
//  ColorID
//
//  Created by Le Nhut on 8/11/18.
//  Copyright © 2018 Le Nhut. All rights reserved.
//

import Foundation
import UIKit

class colorDict {
    public var data = [String:String]()
    private static var ColorDictionary: colorDict = {
        let colorDictionary = colorDict()
        return colorDictionary
    }()
    private var color = UIColor()
    public var ColorFamilies = [
        ["FFBF00", "Hổ phách"],
        ["9966CC","Ametit"],
        ["7FFFD4", "Xanh berin"],
        ["007FFF","Xanh da trời"],
        ["F5F5DC","Be"],
        ["3D2B1F", "Nâu sẫm"],
        ["000000","Đen"],
        ["0000FF","Xanh Lam"],
        ["964B00","Nâu"],
        ["F0DC82","Da Bò"],
        ["CC5500","Cam Cháy"],
        ["C41E3A","Hồng Y"],
        ["960018","Đỏ Yên Chi"],
        ["ACE1AF","Men Ngọc"],
        ["DE3163","Anh Đào"],
        ["007BA7","Xanh hoàng hôn"],
        ["7FFF00","Xanh nõn chuối"],
        ["0047AB","Xanh cô ban"],
        ["B87333","Đồng"],
        ["FF7F50","San Hô"],
        ["FFFDD0","Kem"],
        ["DC143C","Đỏ Thắm"],
        ["00FFFF","Xanh Lơ"],
        ["50C878","Lục Bảo"],
        ["FFD700", "Vàng Kim Loại"],
        ["808080","Xám"],
        ["00FF00","Xanh Lá Cây"],
        ["DF73FF","Vòi Voi"],
        ["4B0082","Chàm"],
        ["00A86B","Ngọc Thạch"],
        ["C3B091","Kaki"],
        ["E6E6FA","Oải Hương"],
        ["CCFF00","Vàng Chanh"],
        ["FF00FF","Hồng Sẫm"],
        ["800000","Hạt Dẻ"],
        ["993366","Cẩm Quỳ"],
        ["c8a2c8","Hoa Cà"],
        ["000080","Lam Sẫm"],
        ["CC7722","Thổ Hoàng"],
        ["808000","Ô Liu"],
        ["FF7F00","Da Cam"],
        ["DA70D6","Lan Tím"],
        ["FFE5B4","Lòng Đào"],
        ["CCCCFF","Dừa Cạn"],
        ["FFC0CB","Hồng"],
        ["660066","Mận"],
        ["003399","Xanh Thủy Tinh"],
        ["CC8899","Hồng Đất"],
        ["660099","Tía"],
        ["FF0000","Đỏ"],
        ["FF8C69","Cá Hồi"],
        ["FF2400","Đỏ Tươi"],
        ["704214","Nâu Đen"],
        ["C0C0C0","Bạc"],
        ["D2B48C", "Nâu Tanin"],
        ["008080","Mòng Két"],
        ["30D5C8","Xanh Thổ"],
        ["FF4D00","Đỏ Son"],
        ["BF00BF","Tím"],
        ["40826D","Xanh Crôm"],
        ["FFFFFF","Trắng"],
        ["FFFF00","Vàng"],
        
    ]
    private init(dataName: String = "ColorDict"){
        if let filepath = Bundle.main.path(forResource: dataName, ofType: "txt") {
            if let content = try? String(contentsOfFile: filepath) {
                let lines = content.components(separatedBy: "\n")
                for line in lines {
                    let colorVals = line.components(separatedBy: ":")
                    guard colorVals.count == 2 else {
                        return
                    }
                    self.data[colorVals[0]] = colorVals[1]
                }
            }
        }
    }
    class func shared() -> colorDict {
        return ColorDictionary
    }
    
    
}


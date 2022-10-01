//
//  ErrorAlert.swift
//  iOSEngineerCodeCheck
//
//  Created by 須崎良祐 on 2022/10/01.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import UIKit

final class ErrorAlert {
    private func showAlert(title: String, message: String = "") -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(defaultAction)
        return alert
    }
    
    func wrongError() -> UIAlertController {
        showAlert(title: "不正なワードの入力", message: "検索ワードの確認を行ってください")
    }
    
    func networkError() -> UIAlertController {
        showAlert(title: "インターネットの非接続", message: "接続状況の確認を行ってください")
    }
    
    func parseError() -> UIAlertController {
        showAlert(title: "データの解析に失敗しました")
    }
}

//
//  GeneralEnums.swift
//  Movilidad
//
//  Created by Diego Quimbo on 3/2/22.
//

import UIKit

enum ItemType: String {
    case O
}

enum OperationType: String {
    case Apps = "8388608"
    case Tile = "1048576"
    case Activities = "262144"
}

public enum MenuTabType: String {
    case Transactions
    case Indicators
    case Workflows
    case Apps
    case Settings
    
    var iconTab: UIImage {
        switch self {
        case .Transactions:
            return Asset.tabOperation.image
        case .Indicators:
            return Asset.tabIndicator.image
        case .Workflows:
            return Asset.tabWorkflow.image
        case .Apps:
            return Asset.tabApp.image
        case .Settings:
            return Asset.tabSettings.image
        }
    }
    
    var iconTabSelected: UIImage {
        switch self {
        case .Transactions:
            return Asset.tabOperationSelected.image
        case .Indicators:
            return Asset.tabIndicatorSelected.image
        case .Workflows:
            return Asset.tabWorkflowSelected.image
        case .Apps:
            return Asset.tabAppSelected.image
        case .Settings:
            return Asset.tabSettingsSelected.image
        }
    }
    
    var iconItem: UIImage {
        switch self {
        case .Transactions:
            return Asset.transactionItem.image
        case .Indicators:
            return Asset.indicatorItem.image
        case .Workflows:
            return Asset.workflowItem.image
        case .Apps:
            return Asset.appItem.image
        case .Settings:
            return UIImage()
        }
    }
}

enum OperationHandlerType: String {
    case ExternalWeb = "externaloperation"
    case Page = "pagehandler"
}

enum FormControlContainerType: String {
    case Container = "container"
    case DataGrid = "datagrid"
}

enum FormControlType: String {
    case Textbox = "textbox"
    case Button = "button"
    case Datebox = "datebox"
    case Checkbox = "checkbox"
    case Grid = "datagrid"
}

enum OperationWebType: String {
    case Operation
    case Workflow
    case Notification
}

enum WebInteropAction: String {
    case camera = "camera"
    case galeryMultiple = "galerymultiple"
    case videocamera = "videocamera"
    case videogalery = "videogalery"
    case videogalerychunck = "videogalerychunck"
    case videoremovetemp = "videoremovetemp"
    case recordaudio = "recordaudio"
    case barcode = "readbarcode"
    case playVideo = "playVideo"
    case playAudio = "playAudio"
    case open = "open:"
    case notificationRegister = "notificationsregister"
    case updateNotificationCount = "updateNotificationCount"
    case multipleOperations = "multipleOperations"
}

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //设置ShareSdk
        ShareSDK.registerApp("11ec043df4531", activePlatforms: [SSDKPlatformType.TypeWechat.rawValue,SSDKPlatformType.TypeSinaWeibo.rawValue,SSDKPlatformType.TypeQQ.rawValue], onImport: { (platForm) -> Void in
            switch platForm {
            case SSDKPlatformType.TypeWechat:
                ShareSDKConnector.connectWeChat(WXApi.classForCoder())
            default:break
            }
            
            }) { (platform, appInfo) -> Void in
                switch platform {
                case SSDKPlatformType.TypeWechat:
                    appInfo.SSDKSetupWeChatByAppId("wxed5ee859fc43fccc", appSecret: "eceed754a00660ba3d68d08f2ad667c1")
                default:break
                }
        }
        
        //设置LeanCloud
        AVOSCloud.setApplicationId("BA3LJI4IUoya3WHhmAk4F90s-gzGzoHsz", clientKey: "pOOG9MR6C3hGl5Rz5mdCEU9K")
        
        
        self.window = UIWindow(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        let tabbarController = UITabBarController()
        
        let rankController = UINavigationController(rootViewController: rankViewController())
        let searchController = UINavigationController(rootViewController: searchViewController())
                let pushController = UINavigationController(rootViewController: pushViewController())



  
        tabbarController.viewControllers = [rankController,pushController,searchController]
        
        let tabbarItem1 = UITabBarItem(title: "1", image: UIImage(named: "CD"), selectedImage: UIImage(named: "CD"))
        let tabbarItem2 = UITabBarItem(title: "创建书评", image: UIImage(named: "CD"), selectedImage: UIImage(named: "CD"))
        let tabbarItem3 = UITabBarItem(title: "3", image: UIImage(named: "CD"), selectedImage: UIImage(named: "CD"))
      
   
        
        rankController.tabBarItem = tabbarItem1
        searchController.tabBarItem = tabbarItem3
        pushController.tabBarItem = tabbarItem2
  
        
        rankController.tabBarController?.tabBar.tintColor = MAIN_RED
        self.window?.rootViewController = tabbarController
        self.window?.makeKeyAndVisible()
    
        return true
    }
}


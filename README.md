# SwiftUIKitDarkMode
darkMode For Swift
使用方式:
将Skin文件夹放入你的工程中，
代码中有XX命名前缀，可以全局替换

代码实例:
let view = UIView()
view.XX_setBackgroundColor(.Color_F7F8F8)

let btn = UIButton()
btn.XX_setTitleColor(.Color_333844, for: .normal)

view.XX_skinDidChangeBlock { view in
   guard let view = view as? UIView else { return}
   view.backgroundColor = XXSkinManager.shared.isDarkMode() ? .red : .blue
}

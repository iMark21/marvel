
import UIKit
import SDWebImage

extension UIImageView {
    func load(url: URL) {
        self.sd_setImage(with: url)
    }
}

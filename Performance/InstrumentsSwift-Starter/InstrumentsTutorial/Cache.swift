/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class ImageCache {
  
  private static let _shared = ImageCache()
  
  var images = [String:UIImage]()
  
  static var shared: ImageCache {
    return _shared
  }
  
  func loadThumbnail(for photo: FlickrPhoto, completion: @escaping FlickrAPI.FetchImageCompletion) {
    // 如果有缓存则从缓存c中去
    if let image = ImageCache.shared.image(forKey: photo.id) {
        completion(Result.success(image))
    } else {
        // 如果没有缓存则 则从FlickrAPI 加载成功之后然后加入缓存
        FlickrAPI.loadImage(for: photo, withSize: "m") { result in
            if case .success(let image) = result {
                ImageCache.shared.set(image, forKey: photo.id)
            }
            completion(result)
        }
    }
  }
}

// MARK: - Custom Accessors
extension ImageCache {
  
  func set(_ image: UIImage, forKey key: String) {
    images[key] = image
  }
  
  func image(forKey key: String) -> UIImage? {
    return images[key]
  }
}

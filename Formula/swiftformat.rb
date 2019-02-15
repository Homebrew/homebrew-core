class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.39.3.tar.gz"
  sha256 "a81bff8ec1092a6721a9fe3853e494e56169ea0ddc190c04b666bb468f404837"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "acd73f7eccb9a74f9d3c4a9f73ea9c2d1c144007a6bce3e7a85c1a2f3e0f4b85" => :mojave
    sha256 "1ccb802e82db625034644272766e46eec396e2696b054003685a7931568e71bc" => :high_sierra
    sha256 "0529ab99018f665600e5634bf5cbde8d6a7ca45ba8979c0130ddc8731a43c78b" => :sierra
  end

  depends_on :xcode => ["9.2", :build]

  def install
    xcodebuild "-project",
        "SwiftFormat.xcodeproj",
        "-scheme", "SwiftFormat (Command Line Tool)",
        "CODE_SIGN_IDENTITY=",
        "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end

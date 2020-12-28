class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.47.9.tar.gz"
  sha256 "29d017bad7b3acc914466260825b0a3ce3b57f4d8dd0971329e6bb90ece449e2"
  license "MIT"
  revision 1
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "1118a66b94451c3fe18384ee70e764602f54a45f099c3d6ed43a15f94c457139" => :big_sur
    sha256 "e172747d1dc9ec1d0889ee42d72a5f0ce8d079e0d6a5414159c4ba14cfb1c9b5" => :arm64_big_sur
    sha256 "51fa6d5c78e1b320de0506d9aad4ca2a20625e33ed4a646170fdc66985f7efe1" => :catalina
    sha256 "9076f9b488ffb2ce613a24c8ecaa862e4994e6bd9355af06151fd811a9e6a332" => :mojave
  end

  depends_on xcode: ["10.1", :build]

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

class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.47.9.tar.gz"
  sha256 "29d017bad7b3acc914466260825b0a3ce3b57f4d8dd0971329e6bb90ece449e2"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "47e3aa92792a53413eb0866d3b6709e88c7164184f406c3e49c560e82a2fe589" => :big_sur
    sha256 "2f7d89f924ecc05ce51146ab1f4ee65a24a4fd54997a03b2680e62bf5c8f337f" => :arm64_big_sur
    sha256 "c268a44da4ed4e7836d2b43f917a1411f3b8f13488ee25c66f4bd8bb2f4d5e05" => :catalina
    sha256 "38abb30c870974c65ee0a3afed11cd5f983ab05a13923061fc67c4b6566df6f8" => :mojave
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

class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.47.5.tar.gz"
  sha256 "696bcc075df9580a29ca3b3427326a8d6fe70fea9d6925da350a3d96428a6924"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "924077040606abc98a03cce55359e074c38d754e124f27b054b5d3035c43c24e" => :big_sur
    sha256 "7785eacec3be9d037d069a1ebe8b4d6d06518ad010e3b4d9da52f342790b59cc" => :catalina
    sha256 "b575bb3a42dc010c293a4115868cfbe54e3e8e86c4d3bd82e92f475f6ebb5de1" => :mojave
    sha256 "fa2359e96aff73b546b0b7d171cfc213ffe9fe08cc03e7a08089f4eea864ee9b" => :high_sierra
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

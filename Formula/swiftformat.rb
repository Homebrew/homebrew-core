class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.45.5.tar.gz"
  sha256 "f85d4fbd7054dd6cd4619edff51e7ff7fee4ca692efe1b8b8ea2188b9a0b9d9d"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "657c919762b0070335931a0b54385bb6ae872522c24835e4a73ef4bc7bc36a22" => :catalina
    sha256 "5d188757e96026c38c4d49555436044070a006b71e8848ec4ca1085dfe551c0e" => :mojave
    sha256 "6d332a0fab5f56769d2b94901ccc6ff8972bf617212a1328ac1386ddd200c0a4" => :high_sierra
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

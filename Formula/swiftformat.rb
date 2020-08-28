class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.46.0.tar.gz"
  sha256 "0d30529165d1dc6f84dd0bcb7b5e066120901123d33cf07ce50153712d2421cf"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "7f23ff740679b30e313c91533c2f3e6fa4210bb68f8e383c29e7f922f87d8f66" => :catalina
    sha256 "b5349b775ff60c73c284d5de8ad2c0fdfb35428cff92bb7a8e5fcc6536750b89" => :mojave
    sha256 "34d900217ca12736a112c31e54a5f4f7e64c1fe224f6e4ea76ad1d25b149f647" => :high_sierra
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

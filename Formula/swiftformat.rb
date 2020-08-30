class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.46.1.tar.gz"
  sha256 "4829c6e961c894ee1ab99e0085818b09f98d011c2a310efa7258b222b143cf0f"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "0f6ad2e60410999fdcc4a37dafc920b5d7a901aac45d8014a2d690d0b059d1ca" => :catalina
    sha256 "ff22af2edf2679fbaf5274f09c589c3d05e82b51dc860f5070ae7bed68ed63f4" => :mojave
    sha256 "df510ed429928d967c6634c919c2c57aa2027afadb97b9d72a1a55b055428656" => :high_sierra
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

class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.43.4.tar.gz"
  sha256 "781b94ff3d2e4a4080bc9a17b81294b9bb50f77473e3f344731bd34653c597a1"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "8dce1700a905672fe6379c928e0d13acdeaedd420f9b74ddd096a75437219531" => :catalina
    sha256 "6ee7c5fa98ca92945aad949e5cb3667082d03445029eba8c6f70733b44339862" => :mojave
    sha256 "709b33b729d4f2ee3712fdf9190ed4d48bcefd4b7192cff2056e1c575c71171f" => :high_sierra
  end

  depends_on :xcode => ["10.1", :build]

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

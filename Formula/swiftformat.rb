class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.44.0.tar.gz"
  sha256 "029448390350b98448b2564df6a22467a5eae7c182e62460a51317099faea8c2"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "a818c36fdf611a109cbf9a4bd5d5e0a69d27369fefe6c640359ce47152a16628" => :catalina
    sha256 "8813cf5166ee33a79ad2110cfeb7371a1832b4d035496a1d9a3821ceeb86f301" => :mojave
    sha256 "645ef8662b17b797ee355d81f9d445ea5abc29687e54f60fbf6dd1cfd40bf9e0" => :high_sierra
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

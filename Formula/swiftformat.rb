class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.39.3.tar.gz"
  sha256 "a81bff8ec1092a6721a9fe3853e494e56169ea0ddc190c04b666bb468f404837"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "edee4fd6bbe41d6e71def6f6698e9dc3acfd77e5cb80a7c6e09f22e248a59c5f" => :mojave
    sha256 "1c58b039439f7091f3c5a5105d3596ae2dbcc343676d245abec08b1ebfe60326" => :high_sierra
    sha256 "c501c8d610219ba439f45179f9234e85cc3e2a7ee1d992e93b26acd2fbafce5a" => :sierra
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

class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.40.1.tar.gz"
  sha256 "b615ea764f71b6420eac48b7aefcfa0fadf33ade62ea5ca80777fc52d2cb776e"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "28c2e074942cbc97892d1003d9161fb60e0c813b0eb2c35b28fb9d9b59b51fce" => :mojave
    sha256 "a4e384851d485368307294cbe089f566285a89e562349ed7d4553e51241c46eb" => :high_sierra
    sha256 "afb8798b36859aae149af8171422bd6e943e3b28d058b045edaad31a341e7417" => :sierra
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

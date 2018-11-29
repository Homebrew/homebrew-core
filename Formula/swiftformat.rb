class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.35.9.tar.gz"
  sha256 "599b5a328c3bba18d5439576aebd509813f393c64b261dbb962f2605f60104f4"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "9f2a033965a981f7b248b060080ee2d5e32c6c2acaf7b6b7452e520010464976" => :mojave
    sha256 "d65ef62dffd045a881a503dbf98cd85c70ab7a36c3b0b9a5b49c0bbd1f81b268" => :high_sierra
    sha256 "baf100e1d6ba20f5ad552919d9b023254e944376d668b0e835aff7ae544ec528" => :sierra
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

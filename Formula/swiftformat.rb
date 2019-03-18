class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.40.1.tar.gz"
  sha256 "b615ea764f71b6420eac48b7aefcfa0fadf33ade62ea5ca80777fc52d2cb776e"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "e9af942be793760287f3b8243276395e1d57de6562e9d24011978c350ed03eb0" => :mojave
    sha256 "cd5dd4aa24f53c90b7bf38600cb8bf28b21524bc8d17a6e8c26de779ec1a463d" => :high_sierra
    sha256 "c78805ec478ca55f18865bb442a76aecc0498897333ada680d1ebffdc5376488" => :sierra
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

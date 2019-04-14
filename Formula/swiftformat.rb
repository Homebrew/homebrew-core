class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.40.6.tar.gz"
  sha256 "476254a8fb8a371ce507c3226eb1dc9a42f192ab13c8c69741ecead1314b8c55"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "bf355d0c12b78fb821f51b34c1a8f06628b43974fb4c0be2124c63a054c955e8" => :mojave
    sha256 "29f237e665e5834e86c27bf7dd5e678ce2545c8c229dc65c16696e1d208a96a5" => :high_sierra
    sha256 "21db85e903cdee56a4783aa80927fd7fc93d78b167e177a291e1e4d5566e8895" => :sierra
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

class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.43.0.tar.gz"
  sha256 "235ce27ec394e1a655b84ca3e73f033c1f859ae64c1273dff8e27711f9e52f82"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "3620b9c2c0a769d9256cacaba49cdd11122f0d0f22161dacb57a6b95f77ad066" => :catalina
    sha256 "f51a6e95e61172ee390a66b1d79faac79e22508ed13b9162e75a65a1763f1f8a" => :mojave
    sha256 "b65ec9c24f46a0e786030367f1ac112ac5b498c8ef93ccf3b63e827be3fc80a7" => :high_sierra
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

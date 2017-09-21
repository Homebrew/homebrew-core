class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.29.6.tar.gz"
  sha256 "e3b496d692536e3143e1ea4398bc0d0ec578dbc2e9dc0fcf2d6b4da32c0bf8af"

  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "e0da68e43b432ec849bfb56257639a755f43f4d7764d1d3600a6d4239f62ae5c" => :high_sierra
    sha256 "43b08b8bec3b04fb892293df91af3dca73eeff5ae48eafaaf8bcc8b39e1c6248" => :sierra
    sha256 "e05834c5ddbbf1935d9fcfe42026494293adf6ecb1232b600a5c5e20fea46e29" => :el_capitan
  end

  depends_on :xcode => ["8.0", :build]

  def install
    xcodebuild "-project",
        "SwiftFormat.xcodeproj",
        "-scheme", "SwiftFormat (Command Line Tool)",
        "CODE_SIGN_IDENTITY=",
        "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<-EOS.undent
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end

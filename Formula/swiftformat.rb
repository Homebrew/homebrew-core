class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.37.0.tar.gz"
  sha256 "4768319047c57faa262aa53b6ae71c9877482801e30803ac461c34239e175346"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "9ba620860f83e5883285fdabd8b1d00f7ee3d55c8c2d27a8e40132e6dc99f345" => :mojave
    sha256 "ee92b97c61a286c808989938ee49a8ed3ac2f54914bfe5068f5c8b9e6b9e33e4" => :high_sierra
    sha256 "ab06df20c14d5abb507e5d6a73c9c9ea10c0370e6cfa2e3c71a0cf4a475c1cef" => :sierra
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

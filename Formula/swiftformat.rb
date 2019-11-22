class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.40.14.tar.gz"
  sha256 "4cccf3580a622868b7c044dd5fba598f43e3d5ea35d6c93d3d8cc27570a90e1d"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "08136ccade36c7764ccd01d21a20a5802d4abfac66e69930b83a71c8e09016d7" => :catalina
    sha256 "1a9fb419dbfe29ca6f2a46ae6072a01814be6c5a2826e315feb8230020efa65a" => :mojave
    sha256 "4a73a3d11f60310f4007eeab495beff7e587e0f84272cba5aded43af30cb5835" => :high_sierra
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

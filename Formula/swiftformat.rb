class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.37.2.tar.gz"
  sha256 "5cf216ff0b89a3d84d0b0df8dad4ce35302ad2a58e2d9e0188bffb60ca8ab6fe"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "25ade2b34b5730044392564f39b14797032e8a5f0c5e8666f05e7b5ddbde5ac9" => :mojave
    sha256 "40f604df00c0ed741f62e89125c7ad41710b5d8de1376a6eb119b9e6f707c477" => :high_sierra
    sha256 "5f56e7350987cfd2ef967ea539dce51c95283b7e54be30a5c6c7e39fc21b837d" => :sierra
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

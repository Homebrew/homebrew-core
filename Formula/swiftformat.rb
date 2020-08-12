class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.45.6.tar.gz"
  sha256 "05687558fc734e0d85e8d8fba2a09a25173b89a694e82605a6916ae0b0649d72"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "49637b1330b664573bdeeac9b66a903ff69bb4555baafb0c0ef52f0a6d74ff56" => :catalina
    sha256 "38ac95f87c0a93fe1b1d131643092d320df89493621ac7ccc5676cfc1e46cb36" => :mojave
    sha256 "6b57ce383522bf35ea3296990ef94ee6ad7f651cdc66bf724e89d0c026642116" => :high_sierra
  end

  depends_on xcode: ["10.1", :build]

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

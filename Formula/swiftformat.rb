class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.47.13.tar.gz"
  sha256 "df1af7ed99d2cdd536a16556a17b98db91bf3cd28612d3637f289337a2309478"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fdcdb5e94b9c4d66a32d4515ba3d2db4057865f96aefab0e41fdeaf2879f4f89"
    sha256 cellar: :any_skip_relocation, big_sur:       "cbb7a9803926d8bfaacf5c1a7d4cd07d8fe2255b1885be3ae2ffd8414e4c5292"
    sha256 cellar: :any_skip_relocation, catalina:      "3a13e9b1f4a63bc03601897944f71dd4e6942788531dc060322d20fc6b36d2fd"
    sha256 cellar: :any_skip_relocation, mojave:        "4e0691f12a5ef3b01eba9f41091b8f3457bc65151bfad057a45e8de9525074cd"
  end

  depends_on xcode: ["10.1", :build]

  def install
    xcodebuild "-project",
        "SwiftFormat.xcodeproj",
        "-scheme", "SwiftFormat (Command Line Tool)",
        "-configuration", "Release",
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

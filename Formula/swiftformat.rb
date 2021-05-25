class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.48.3.tar.gz"
  sha256 "1cbab865086f715e544e0cf67d638631444d95bb87d365d75eef16efbc763a49"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "45f0d1d25e117bba4d30e3077c3445052bf4bb5238419a0747d851adbede06d1"
    sha256 cellar: :any_skip_relocation, big_sur:       "fbc54de6090d46e3b63592e7d304871aced14d43d2b4b23dcef1bc997b4dd8a0"
    sha256 cellar: :any_skip_relocation, catalina:      "10aa177bc5b37892d4ec96e61051cf8ff5d12c6deeaef8cd276a0b2589c14848"
    sha256 cellar: :any_skip_relocation, mojave:        "4be65d16c76254414d779ebc8b7e0722d728657a21f6eeef29c7a15842dbc741"
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

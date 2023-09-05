class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.52.3.tar.gz"
  sha256 "b4e9e9fa35f3a0b159694d46fba8cc6c614ac9c07641ba3195b3cca5da60f669"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c60e18bc44c0781d97a96c536aa8bb6e762b79008927c5e7307dcf2c69b6058"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d63d1affcfba1ea8b6bf035d4abd834bf2effe0c0cf385ba608f98341da1c837"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d80ec81a9140159181b77145d2dfdcd38488b23b262ef1bd74ab7163d0cbebae"
    sha256 cellar: :any_skip_relocation, ventura:        "274da364741558f1f52780e9a92354db212a803cf5d84c2ca9ff632d94ada47d"
    sha256 cellar: :any_skip_relocation, monterey:       "b53d82e6f2d42bf1e6fa799983fdfae934b483bc916c34436184fcb7e407f896"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bd117c9e2f92bde0f59a4106748a56e57687a1716627ef601e63b15a383ea35"
    sha256                               x86_64_linux:   "384fee82f88b4bf8b30cfe9cec946ebd9127a4741b28e06cec42fc0d9b70c0f6"
  end

  depends_on xcode: ["10.1", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/swiftformat"
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

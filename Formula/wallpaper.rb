class Wallpaper < Formula
  desc "Manage the desktop wallpaper"
  homepage "https://github.com/sindresorhus/macos-wallpaper"
  url "https://github.com/sindresorhus/macos-wallpaper/archive/v2.1.0.tar.gz"
  sha256 "4925247524535c0cc128dcc4d87f5538a5ce3b5d3a3c211127fd646ee00252b6"
  license "MIT"
  revision 1
  head "https://github.com/sindresorhus/macos-wallpaper.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "465c12ed22256d886bbcb848c4dd7bf1c902867612c945b64078bdc8f18e604a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c287fd0c20f380e5da1a0d164b7199b8280f868dd994a86002f06481fc5db36a"
    sha256 cellar: :any_skip_relocation, monterey:       "92659abc7da0921016ff9847a58a77b778f981d99d6c1ea722571b668a292cba"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a4cb8a6ee394116921c900caf783e14eccd0f36bc75d1490b879fa613503922"
    sha256 cellar: :any_skip_relocation, catalina:       "2a2ca640dde6aed8dab04983c680d60532eefcadc11f3c0b379e7754d4d9a662"
  end

  depends_on xcode: ["11.4", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/wallpaper"
  end

  test do
    system "#{bin}/wallpaper", "get"
  end
end

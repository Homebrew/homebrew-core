class Ttyplot < Formula
  desc "Realtime plotting utility for terminal with data input from stdin"
  homepage "https://github.com/tenox7/ttyplot"
  url "https://github.com/tenox7/ttyplot/archive/refs/tags/1.6.2.tar.gz"
  sha256 "99222721e2d89e1064546f29e678830ccaba9b75f276a4b6845cc091169787a0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d52cadbdafa654723354871e864b03a6a09758a2564802d8ed0ff00fb8efe22"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4d268c520b73ce0dfeb8fe0b15e48c4cec8cfcfecc480a76ea7ab3e6130b26a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c28c176f16b68540dc4757da83ffec41a51ff0663580f1267236227768fbd772"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b11f61c394f9afb119180717c14f84e63e3d32bbe3cbeace81750cb6b8987e0"
    sha256 cellar: :any_skip_relocation, ventura:        "da7596531a646453653e8b2cfe1cde83759aee2f97bde6aa0feb73b4d5068659"
    sha256 cellar: :any_skip_relocation, monterey:       "81e39a835173b64ca69a8023011c809102407e264b4d1bca355ac72bec3e2c74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a97f7c0ae188115e77d7b7efb75b2b037a568edaea74d12bd040940f5643dbde"
  end

  depends_on "pkg-config" => :build
  uses_from_macos "ncurses"

  def install
    system "make"
    bin.install "ttyplot"
  end

  test do
    # `ttyplot` writes directly to the TTY, and doesn't stop even when stdin is closed.
    assert_match "unit displayed beside vertical bar", shell_output("#{bin}/ttyplot -h")
  end
end

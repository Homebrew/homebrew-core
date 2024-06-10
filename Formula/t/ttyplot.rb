class Ttyplot < Formula
  desc "Realtime plotting utility for terminal with data input from stdin"
  homepage "https://github.com/tenox7/ttyplot"
  url "https://github.com/tenox7/ttyplot/archive/refs/tags/1.6.5.tar.gz"
  sha256 "485727db235862855687cb134fae96fcb465b622713aa40df006731cc554a268"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64d5c0fddfe081762e57812253163d065df0212c9b288be3c2d2920f875b1bf5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "793b486722ce86c6a565fca142991e437d8e6cf16010885cc4beb5a9eb8923dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc6526451978305d22276e52e0abf2eb03ec824cfcb34927071efc2a57d9c710"
    sha256 cellar: :any_skip_relocation, sonoma:         "34caf3ebb8fdc1f266ad325124f7e38d54b51b9d38f2d6d90ea46a76ed79ca92"
    sha256 cellar: :any_skip_relocation, ventura:        "b6020731c5c78eea23a6911631a4f56fc300a952497a8894663f5d6762016c2b"
    sha256 cellar: :any_skip_relocation, monterey:       "a16ad8503320efec9d9123987c5adde5bdb66d0c4d7df30bbc03a12db742b1d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f54884cecf722d402498e7081a696dbcef6b52aaebe11935a1a7a76296946b88"
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

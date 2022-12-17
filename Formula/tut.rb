class Tut < Formula
  desc "TUI for Mastodon with vim inspired keys"
  homepage "https://tut.anv.nu"
  url "https://github.com/RasmusLindroth/tut/archive/refs/tags/1.0.26.tar.gz"
  sha256 "693fd151640127d3f90aec5b8766cacb0317d8e3609e4ca1b7fd460da0b01dfe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5711043c19f784af01522502a7d752307282f0d5fbd04b80051a47fb5950526c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "524308fa3d485105aab99573878a13b15fa4ae5255d806e0a093dff3442e8dfe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "987f3d32819b1276110fc979470a43848b528b653da042d2141583b6416100b0"
    sha256 cellar: :any_skip_relocation, ventura:        "e745125a94f164c229ae00c69a14c8e8b20c582b5e684224b53b9eac0296e68c"
    sha256 cellar: :any_skip_relocation, monterey:       "a8fdfb15a3abd7174edb711e64a493c7d3d8ceed7fa064550585dc74b5f46a03"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee04e0ff785f2b778069f60a270e5d2de3521de8798435b8ba1c4b36800122b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "490df34fc55d6345737dd67c3597db0087ed22146b150f4894ea1a60f7011069"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tut --version")
    assert_match "Instance:", pipe_output("#{bin}/tut --new-user 2> /dev/null")
  end
end

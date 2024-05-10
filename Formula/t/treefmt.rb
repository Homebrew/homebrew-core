class Treefmt < Formula
  desc "One CLI to format the code tree"
  homepage "https://github.com/numtide/treefmt"
  url "https://github.com/numtide/treefmt/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "5bb67936c5e1dfdb0f260e0f1795e1624697e266c6c1b9e47914df4aa17c5107"
  license "MIT"

  head "https://github.com/numtide/treefmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bba21b0bdd6ae7fd7569524b658681208c89672cb0eb92629c758f21e488e16c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ded3e211ab31c99263044c87cab977a4b614834acf31c14e699918b6c8bad104"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44ae0868f85b77fb10d3cba220448f6e1cf8e5b8e877cb841028b39aad203f4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "80c344cc850282f3a0dfb58b01900069b94e07c9a6495842caca856dc2a183bc"
    sha256 cellar: :any_skip_relocation, ventura:        "64e5fd37315933d10520ebe86a8c30aa721338c62a2f1eaa924f28f5b885fc66"
    sha256 cellar: :any_skip_relocation, monterey:       "0896efaa39e5d6f9ec65076c930427de27b0ed3b7daf8178eb3380a2c0306ddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00f0145abdd2b5c97fae57564e6f3db8349c712f6f935f33e3d941d27e1bf124"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that treefmt responds as expected when run without treefmt.toml config
    assert_match "treefmt.toml could not be found", shell_output("#{bin}/treefmt 2>&1", 1)
  end
end

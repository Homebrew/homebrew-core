class Term < Formula
  desc "Open terminal in specified directory (and optionally run command)"
  homepage "https://github.com/liyanage/macosx-shell-scripts/blob/HEAD/term"
  url "https://raw.githubusercontent.com/liyanage/macosx-shell-scripts/e29f7eaa1eb13d78056dec85dc517626ab1d93e3/term"
  version "2.1"
  sha256 "a0a430f024ff330c6225fe52e3ed9278fccf8a9cd2be9023282481dacfdffb3c"

  livecheck do
    skip "Cannot reliably check for new releases upstream"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dd9dd17ed477530310c64097beb15b38091a3b63c90c76289908ac550bb83d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52285aea926cdf84f92702472ba404054f0297444f88a99a1f9b3916cbadf485"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f243e5462a56dc1847cea21bc43517688daa6f82bffac8aafd8c68258cfafa7f"
    sha256 cellar: :any_skip_relocation, ventura:        "1167465716e88902f005f60826fa6fa4453c869fdbfa23572e68e2447d9b6844"
    sha256 cellar: :any_skip_relocation, monterey:       "010a8465dd589036df16f10d9847f543b0a7c42a67b1dd25bbd55a07f0bd6001"
    sha256 cellar: :any_skip_relocation, big_sur:        "98c1bad8f19eab761b3917c8b065830d296f2d700670ffcdf0fee0fa322fa1f1"
    sha256 cellar: :any_skip_relocation, catalina:       "06049c5857c19cb0ca6e794c44ca0f10974dbba5f1da561e6af0fb3fe1b019e7"
    sha256 cellar: :any_skip_relocation, mojave:         "bd69041cc6a4321552e29381fbdb0d5cbb09d84e89be8344a3ed90611ba7d51a"
  end

  depends_on :macos

  def install
    bin.install "term"
  end
end

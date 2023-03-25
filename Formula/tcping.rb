class Tcping < Formula
  desc "TCP connect to the given IP/port combo"
  homepage "https://github.com/mkirchner/tcping"
  url "https://github.com/mkirchner/tcping/archive/2.1.0.tar.gz"
  sha256 "b8aa427420fe00173b5a2c0013d78e52b010350f5438bf5903c1942cba7c39c9"
  license "MIT"
  head "https://github.com/mkirchner/tcping.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7de0e3c838aaae2bb89c7bd0b67c6f266da6e2ad1b51bacfec12bf0dcd571c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c35447b3eeb2f311ff02d7a58ee3ba6e5ed9193e4af6dd3e6873b726045a6dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28147cc42e3e3ff56544541e124c3ddec85f87890916b92d001b8e9c3a782a3a"
    sha256 cellar: :any_skip_relocation, ventura:        "355031cff4f82340d5283340b37d32a16ad4b8e8613943d6f5436776111f72e2"
    sha256 cellar: :any_skip_relocation, monterey:       "0409b29a41d9adfdf9d91cdb8636ee22283d5f345a9b407ad38c2d5db9d82ff3"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e910be778fecc34bdecd3acd26c3d886cbc4306b7737cd81369cc0b11ab9253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5aec7e868a2ceca9e43880197661cb2d21d17f26ca7570e13072444c8f9b616"
  end

  def install
    system "make"
    bin.install "tcping"
  end

  test do
    system "#{bin}/tcping", "www.google.com", "80"
  end
end

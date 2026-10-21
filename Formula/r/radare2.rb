class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/refs/tags/6.2.4.tar.gz"
  sha256 "24f3f7ad24f44defc8fd1460a210f08a40980e0d5555b8e8439da8a92c54dac5"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "9248691bf8a04ab3e97eabe2ad20fe88f254d581d40e85f4df59d4fe90e78a0c"
    sha256 arm64_tahoe:       "3776eaa0827790f571e63ecb9b8819405dc6dca965e41214de5278f1d79ae42d"
    sha256 arm64_sequoia:     "ff68cee0af6b9274063fe09712a6a59182f31184d08f476664310351646bbe51"
    sha256 arm64_linux:       "908d5253f2c64d5a43b278eeaa7fff25506f21e8d4d2f0033fa419016e612317"
    sha256 x86_64_linux:      "234df2b07bb3c4174bce38e04d3d761148d9d6b43049e05086e8f37e718ddacf"
  end

  # Required for r2pm (https://github.com/radareorg/radare2-pm/issues/170)
  depends_on "pkgconf"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -v")
  end
end

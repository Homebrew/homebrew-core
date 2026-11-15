class Sponge < Formula
  desc "Soak up standard input and write to a file"
  homepage "https://joeyh.name/code/moreutils/"
  url "https://deb.debian.org/debian/pool/main/m/moreutils/moreutils_0.70.orig.tar.xz"
  sha256 "a844c5e3360a73d12c0a5624750ecc1969d64afea2e84925328f137576e2eb55"
  license "GPL-2.0-only"
  head "https://git.joeyh.name/git/moreutils.git", branch: "master"

  livecheck do
    formula "moreutils"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c43829463447d0af8bc280244cb51f3475ccbaa0aa25e6df5ac0ad84e5b1936d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2e2d3741a4785752350c23b396da6ea546edf3e878cba7d310173914c1d410b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "96d029deedc6429cd8fc60e2ffe8ecdd62088727af8e76e557a773099a239a83"
    sha256 cellar: :any,                 arm64_linux:       "00d4ee094988bfacda5e5f03ff4bc1caea3298785cf09f8466b65aaee6ca8a29"
    sha256 cellar: :any,                 x86_64_linux:      "c4d294043da69edc76cc2756656376d3b42a164676ee318b3457e9f29fbdd8d8"
  end

  conflicts_with "moreutils", because: "both install a `sponge` executable"

  def install
    system "make", "sponge"
    bin.install "sponge"
  end

  test do
    file = testpath/"sponge-test.txt"
    file.write("c\nb\na\n")
    system "sort #{file} | #{bin/"sponge"} #{file}"
    assert_equal "a\nb\nc\n", File.read(file)
  end
end

class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.8.4.tar.gz"
  sha256 "8ea45bd82e5ea37e270ca14ac2a6f947c647a24f9de9e18bf8cebc71c0816dcd"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "e82288921d7cb01a282922056ec93fe46573196fb6d68b4a09e68f0f4cd48dd9"
    sha256 arm64_monterey: "11e46cd24d5c79725f8501184a430c82eaccc8341028e4a6ddcc59dd8f27d4df"
    sha256 arm64_big_sur:  "7dc4af3c152f9e90316bc1a70ae12ab16843094b721adcacd2d1b3c5cffc6784"
    sha256 ventura:        "64e057784a4905d405fa33c364f631398043bb9dd95592c380b0914693c4248a"
    sha256 monterey:       "aca69c95d07be0432cf1ddfd916f97f74687d3c551f3aebf8731393193e633ca"
    sha256 big_sur:        "50bdc88597a52c1d9e0842970240288ddbcc3d518791f01e390ec016aedbfacd"
    sha256 x86_64_linux:   "9123c012b0040387520d08428a423489c269b3bb93ec8bd16da45eb17646a7b3"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -v")
  end
end

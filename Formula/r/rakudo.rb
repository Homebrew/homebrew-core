class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2024.04/rakudo-2024.04.tar.gz"
  sha256 "c9a8e470c2d203e42ba7115a2c0a0ee8006f0377993de8ec34d2dfa1359c6a89"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "fb18c607f8965d2a62c23c1370d5aaf39a794b1a615c63fb6cce5526831a1496"
    sha256 arm64_ventura:  "6e8cd98bd2bdc9dc666b82176118360cc89dc0cd28b9b05e9aa781d782690202"
    sha256 arm64_monterey: "d78bb1aff173b9068431e1d53fdc0e60271b5f4a32ff63ed5d2a43ebc1c0b5d5"
    sha256 sonoma:         "b7136dc88c334309f4d590aef4bf49ea55bafd9934ff4d641cc1b2839174b283"
    sha256 ventura:        "3a219133ac628ee76925953eb95305fb5b63888ae1f39ee353e7f8e66f39378e"
    sha256 monterey:       "1cac8c140fb4a1be3624285ef83d1b3ceed9f550276986f3fb81d843434b0ec8"
    sha256 x86_64_linux:   "1ae9e21cba59835c3e921bc4f303a0143cb02cd7209c9fa36fb7c802a8eed62e"
  end

  depends_on "libtommath"
  depends_on "libuv"
  depends_on "nqp"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star"

  def install
    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-nqp=#{Formula["nqp"].bin}/nqp"
    system "make"
    system "make", "install"
    bin.install "tools/install-dist.raku" => "raku-install-dist"
  end

  test do
    out = shell_output("#{bin}/raku -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'")
    assert_equal "0123456789", out
  end
end

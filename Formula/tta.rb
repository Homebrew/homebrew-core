class Tta < Formula
  desc "Lossless audio codec"
  homepage "https://web.archive.org/web/20100131140204/true-audio.com/"
  url "https://downloads.sourceforge.net/project/tta/tta/libtta/libtta-2.2.tar.gz"
  sha256 "1723424d75b3cda907ff68abf727bb9bc0c23982ea8f91ed1cc045804c1435c4"

  bottle do
    cellar :any_skip_relocation
    sha256 "af41c210ceddaa4957dc8bc4fec9dedb839157914c3d2d9fbb4bed63239cd9f1" => :catalina
    sha256 "898e75423e5f2a1f872b7ce2e2258db686f09ea04edf56555b15c113f04e9141" => :mojave
    sha256 "10ec40111e20f5168d67b02c52b464065e72fa48060c37a5fd86907062e8a997" => :high_sierra
    sha256 "7a3c44b675bbaf81041c7eeacef622fab8fe3abbc83329a927a1ed0034231b1f" => :sierra
    sha256 "0543d1561fe44fc6137f90076d247f16e6ac28e72413a7ba3bac08d422bb4e9c" => :el_capitan
    sha256 "e25b0a3c395c62d2cb130f4817e405a9e09494c92c17fc71bf123d72b6da5f06" => :yosemite
    sha256 "1b4bdda9786729fffe279cd17faea744108198064d2effcc42b078eb85862671" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-sse4"
    system "make", "install"
  end
end

class Tta < Formula
  desc "Lossless audio codec"
  homepage "http://www.true-audio.com"
  url "https://downloads.sourceforge.net/project/tta/tta/libtta/libtta-2.2.tar.gz"
  sha256 "1723424d75b3cda907ff68abf727bb9bc0c23982ea8f91ed1cc045804c1435c4"

  bottle do
    cellar :any_skip_relocation
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

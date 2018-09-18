class Qdae < Formula
  desc "Quick and Dirty Apricot Emulator"
  homepage "https://www.seasip.info/Unix/QDAE/"
  url "https://www.seasip.info/Unix/QDAE/qdae-0.0.10.tar.gz"
  sha256 "780752c37c9ec68dd0cd08bd6fe288a1028277e10f74ef405ca200770edb5227"

  bottle do
    sha256 "0d4d08d365cd0945d39a04cf9ffdff5b8692dd4b0038553398a62e7b25361590" => :mojave
    sha256 "60fdb0801b8db3e5b36bc896aca8d4e71278ffe2106019e38f34ffd9605500ec" => :high_sierra
    sha256 "bf2425bdeea4a4ac407056410f6758d44f2b31a9c9afc13871f96914c1d17651" => :sierra
    sha256 "b8882074853ecfcbf6d2426361d5baa553380efbb5896777f0c829cac65811a4" => :el_capitan
    sha256 "1a4eeaff6ff2a86179b673c04837aebe2664ca1eeb065e3081296f653b762cc7" => :yosemite
  end

  depends_on "libxml2"
  depends_on "sdl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<~EOS
    Data files are located in the following directory:
      #{share}/QDAE
  EOS
  end

  test do
    assert_predicate bin/"qdae", :executable?
  end
end

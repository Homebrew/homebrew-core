class Qdae < Formula
  desc "Quick and Dirty Apricot Emulator"
  homepage "https://www.seasip.info/Unix/QDAE/"
  url "https://www.seasip.info/Unix/QDAE/qdae-0.0.10.tar.gz"
  sha256 "780752c37c9ec68dd0cd08bd6fe288a1028277e10f74ef405ca200770edb5227"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?qdae[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "9551d2289bd90b76851cebd6d1f11e2e3b1c9ca856d8eb4f88312ec941efb097"
    sha256 big_sur:       "1e6b4a1ae9c0f6c69623f72e6d84429f57986b6560939cfa7ea02b36a2f39830"
    sha256 catalina:      "d951231205b4f4faf3e4f829665d25c82d236f3f52339dd5664fb8adb46e68eb"
    sha256 mojave:        "290d931e61684c53227e0a16d808427eb7218fbec76c57eb250c03dbf15bb6b8"
    sha256 high_sierra:   "945b28c4354053f3ebd81bb868ef6a14d8fef1c32d6cebd73455bd17f17332ae"
    sha256 x86_64_linux:  "663f3822c76388f597539c10e9296fb58289d364902b86497f037843cce25d85"
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

  def caveats
    <<~EOS
      Data files are located in the following directory:
        #{share}/QDAE
    EOS
  end

  test do
    assert_predicate bin/"qdae", :executable?
  end
end

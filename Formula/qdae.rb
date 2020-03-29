class Qdae < Formula
  desc "Quick and Dirty Apricot Emulator"
  homepage "https://www.seasip.info/Unix/QDAE/"
  url "https://www.seasip.info/Unix/QDAE/qdae-0.0.10.tar.gz"
  sha256 "780752c37c9ec68dd0cd08bd6fe288a1028277e10f74ef405ca200770edb5227"

  bottle do
    rebuild 1
    sha256 "d951231205b4f4faf3e4f829665d25c82d236f3f52339dd5664fb8adb46e68eb" => :catalina
    sha256 "290d931e61684c53227e0a16d808427eb7218fbec76c57eb250c03dbf15bb6b8" => :mojave
    sha256 "945b28c4354053f3ebd81bb868ef6a14d8fef1c32d6cebd73455bd17f17332ae" => :high_sierra
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

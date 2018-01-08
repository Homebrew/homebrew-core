class Vcdimager < Formula
  desc "(Super) video CD authoring solution"
  homepage "https://www.gnu.org/software/vcdimager/"
  url "https://ftp.gnu.org/gnu/vcdimager/vcdimager-2.0.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/vcdimager/vcdimager-2.0.1.tar.gz"
  sha256 "67515fefb9829d054beae40f3e840309be60cda7d68753cafdd526727758f67a"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ea434b6d2226040ccaa7388f7ba62cf76e9880b1d217dad26aaa63df2f9c288b" => :high_sierra
    sha256 "59957ad8a3bb455109702642e74331516b78ac4f1e0cb8d1d49c1c511a96dcad" => :sierra
    sha256 "d5ca88f0277e42290bb8f3b1e9e2dc88226393a5fd19161b0db75640d5b2bb09" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libcdio"
  depends_on "popt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"vcdimager", "--help"
  end
end

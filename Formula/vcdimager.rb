class Vcdimager < Formula
  desc "(Super) video CD authoring solution"
  homepage "https://www.gnu.org/software/vcdimager/"
  url "https://ftp.gnu.org/gnu/vcdimager/vcdimager-0.7.24.tar.gz"
  mirror "https://ftpmirror.gnu.org/vcdimager/vcdimager-0.7.24.tar.gz"
  sha256 "075d7a67353ff3004745da781435698b6bc4a053838d0d4a3ce0516d7d974694"
  revision 1

  bottle do
    cellar :any
    sha256 "a325c74f239c0725d111f985ec71685a07a53de3ce15679e61ec78f50b23cfc6" => :sierra
    sha256 "8f800ed3ad7177dad0454bcbf2be01b6a0af894065b826e6658f69fb6b5bc5b5" => :el_capitan
    sha256 "8aa2aca8cb42e7205f209784aa38a917ef33ccc987cffc2d35a86d30a74af519" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libcdio"
  depends_on "popt"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"vcdimager", "--help"
  end
end

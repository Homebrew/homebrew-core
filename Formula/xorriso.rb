class Xorriso < Formula
  desc "ISO9660+RR manipulation tool"
  homepage "https://www.gnu.org/software/xorriso/"
  url "https://ftp.gnu.org/gnu/xorriso/xorriso-1.5.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/xorriso/xorriso-1.5.0.tar.gz"
  sha256 "a93fa7ae5bb1902198cddfec25201388156932f36f2f5da829bf4fcae9a6062b"

  bottle do
    rebuild 1
    sha256 "3bf163215648c9e63a6fa03746ebff1dec15c9aff6204788db2a43e24ab9cb28" => :mojave
    sha256 "45f3af489e20189f73248b0c5444cc0a986f1028c23959aeaf240173bebabeee" => :high_sierra
    sha256 "e7ddc12178ac466d7aceaa3786b070829582b6c5adeb59ca383eeab3fa866e89" => :sierra
    sha256 "dd920cbec3a5d95504763a4129aa915031bc124285ddb16d7ff76c15cecb9724" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"

    # `make install` has to be deparallelized due to the following error:
    #   mkdir: /usr/local/Cellar/xorriso/1.4.2/bin: File exists
    #   make[1]: *** [install-binPROGRAMS] Error 1
    # Reported 14 Jun 2016: https://lists.gnu.org/archive/html/bug-xorriso/2016-06/msg00003.html
    ENV.deparallelize { system "make", "install" }
  end

  test do
    system bin/"xorriso", "--help"
  end
end

class Xorriso < Formula
  desc "ISO9660+RR manipulation tool"
  homepage "https://www.gnu.org/software/xorriso/"
  url "https://ftp.gnu.org/gnu/xorriso/xorriso-1.4.6.tar.gz"
  mirror "https://ftpmirror.gnu.org/xorriso/xorriso-1.4.6.tar.gz"
  sha256 "526f728c7eee6f8c4b69fbf391789e6c80806197c2861cf5922cf7cfe1035784"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c79b906af77a5357e4e7c655f54b90a97a38db27a05129d11b288ea12699ae2" => :sierra
    sha256 "2b3e85b7f982609b3d4597911d8efb7be9763250a2782cc5fdfa4ccd84ce55de" => :el_capitan
    sha256 "8668c56cfceff0b4349cea27ed5a071594fadd6cd264b075b0cfee3e37e818d0" => :yosemite
    sha256 "eafe10c889b4376d999294cd1d13b25f4794ae5fea30f8dce4a846020b62cfcf" => :mavericks
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

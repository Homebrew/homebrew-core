class Xorriso < Formula
  desc "ISO9660+RR manipulation tool"
  homepage "https://www.gnu.org/software/xorriso/"
  url "https://ftp.gnu.org/gnu/xorriso/xorriso-1.5.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/xorriso/xorriso-1.5.2.tar.gz"
  sha256 "3b69f5c93ae7c40c5bbe4a847fa3963f5efc9c565551622f77121c5792fc17e7"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c01b05dd22306a29484078da2cf1909a25e661230b04b58a5248cfa494c9d98" => :catalina
    sha256 "94466282e1c9bd2bf8413ac74a64d666b760e709743406b3f8aec567bb29b5ed" => :mojave
    sha256 "6711eba38184bf837ecba822ce31d0082a886056c00a3bb69468541ac3b81000" => :high_sierra
    sha256 "c8692c6f0ab92fbd688733b1e857eb6d9dcf629e07e31bb7b8d029337e51d7f0" => :sierra
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

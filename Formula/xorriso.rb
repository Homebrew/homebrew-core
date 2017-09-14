class Xorriso < Formula
  desc "ISO9660+RR manipulation tool"
  homepage "https://www.gnu.org/software/xorriso/"
  url "https://ftp.gnu.org/gnu/xorriso/xorriso-1.4.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/xorriso/xorriso-1.4.8.tar.gz"
  sha256 "ec82069e04096cd9c18be9b12b87b750ade0b5e37508978feabcde36b2278481"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec7b002127b53ef237e0c7004e567b0b15ee23deca813ae9ba93dbbc8e9d37d5" => :sierra
    sha256 "050eba14607cb39d805ac97cd2869f59e617b01b537c4ee4d7189a6a2bb11d46" => :el_capitan
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

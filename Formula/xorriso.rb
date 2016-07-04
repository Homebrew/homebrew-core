class Xorriso < Formula
  desc "ISO9660+RR manipulation tool"
  homepage "https://www.gnu.org/software/xorriso/"
  url "https://ftpmirror.gnu.org/xorriso/xorriso-1.4.4.tar.gz"
  mirror "https://www.gnu.org/software/xorriso/xorriso-1.4.4.tar.gz"
  sha256 "f9b954133324281e8dca6e2a3f0b101be02c3d353587bdc520d033c57743fbc7"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e9c949005d71d7cef9779fca8934b129d0c740fccd432f629bf759cdfbc7ec7" => :el_capitan
    sha256 "86a2ef87dc3d1880050a155e2662f68838ab99d6996695e0259e1fdc04cd5e73" => :yosemite
    sha256 "f367a006365ecd19ac68c8af6d86f5a15cc872e2f9e3e7b0e0e002d671d395af" => :mavericks
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

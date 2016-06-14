class Xorriso < Formula
  desc "ISO9660+RR manipulation tool"
  homepage "https://www.gnu.org/software/xorriso/"
  url "http://ftpmirror.gnu.org/xorriso/xorriso-1.4.2.tar.gz"
  mirror "https://www.gnu.org/software/xorriso/xorriso-1.4.2.tar.gz"
  sha256 "2843beded1aa4c678706e96fdf9cc5e4b34430b559bdf5bc35df5202125004b3"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e9c949005d71d7cef9779fca8934b129d0c740fccd432f629bf759cdfbc7ec7" => :el_capitan
    sha256 "86a2ef87dc3d1880050a155e2662f68838ab99d6996695e0259e1fdc04cd5e73" => :yosemite
    sha256 "f367a006365ecd19ac68c8af6d86f5a15cc872e2f9e3e7b0e0e002d671d395af" => :mavericks
  end

  # Upstream fix for "unknown type name 'ssize_t'"
  # See http://lists.gnu.org/archive/html/bug-xorriso/2016-05/msg00001.html
  patch :p0 do
    url "http://bazaar.launchpad.net/~libburnia-team/libisofs/scdbackup/diff/1319"
    sha256 "c548c59b143efb87ccb3dc08f80f527ae93918fab56894c9f8876f31dccce142"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"

    # `make install` has to be deparallelized due to the following error:
    #   mkdir: /usr/local/Cellar/xorriso/1.4.2/bin: File exists
    #   make[1]: *** [install-binPROGRAMS] Error 1
    # Reported 14 Jun 2016: http://lists.gnu.org/archive/html/bug-xorriso/2016-06/msg00003.html
    ENV.deparallelize { system "make", "install" }
  end

  test do
    system bin/"xorriso", "--help"
  end
end

class Xorriso < Formula
  desc "ISO9660+RR manipulation tool"
  homepage "https://www.gnu.org/software/xorriso/"
  url "http://ftpmirror.gnu.org/xorriso/xorriso-1.4.2.tar.gz"
  mirror "https://www.gnu.org/software/xorriso/xorriso-1.4.2.tar.gz"
  sha256 "2843beded1aa4c678706e96fdf9cc5e4b34430b559bdf5bc35df5202125004b3"

  bottle do
    cellar :any_skip_relocation
    sha256 "9166d527cb3b26aadf5a7304e4110e38c30e34e94721c120ea1334205f1d275e" => :el_capitan
    sha256 "99291dcf6826ec15b82c9d32ddae8279244f304661f23e1086f69392ce14f34c" => :yosemite
    sha256 "611ac7bb03593af3216d772b0d4d0b3b5797257dd656b3eb04db3da0f7582f7d" => :mavericks
    sha256 "88442ed4676b021a09bafeef4cd3b40a7e822bb7b4239a1de0518360eefbd5a6" => :mountain_lion
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

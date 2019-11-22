class RxvtUnicode < Formula
  desc "Rxvt fork with Unicode support"
  homepage "http://software.schmorp.de/pkg/rxvt-unicode.html"
  url "http://dist.schmorp.de/rxvt-unicode/rxvt-unicode-9.22.tar.bz2"
  sha256 "e94628e9bcfa0adb1115d83649f898d6edb4baced44f5d5b769c2eeb8b95addd"
  revision 3

  bottle do
    sha256 "d17b7410c97c5f95f1abbf7de7e49249995b23303696b8f7a2eed7c0924fe818" => :catalina
    sha256 "126bda5982eb1d785cdaf84ab108024d85c3904cc3039514f13e12ebb80652a9" => :mojave
    sha256 "01a97a5842a1507ae1e9c99d973811e300d0aac95b3fb744e8181918b6ac11eb" => :high_sierra
    sha256 "2946f3abe2481ad6e4f52be7a9e51259bcd0846f38602e74384343946479eb4a" => :sierra
    sha256 "5d6060cc30061763809d7255b8654309be0a709fccdcda1b799f0fac16fd085d" => :el_capitan
    sha256 "9b674dd3738ab25fa6145680f92ca036df470ced089448abcb6647439320e075" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on :x11

  # Patches 1 and 2 remove -arch flags for compiling perl support
  # Patch 3 fixes `make install` target on case-insensitive filesystems
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/rxvt-unicode/9.22.patch"
    sha256 "a266a5776b67420eb24c707674f866cf80a6146aaef6d309721b6ab1edb8c9bb"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-256-color
      --with-term=rxvt-unicode-256color
      --with-terminfo=/usr/share/terminfo
      --enable-smart-resize
      --enable-unicode3
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    daemon = fork do
      system bin/"urxvtd"
    end
    sleep 2
    system bin/"urxvtc", "-k"
    Process.wait daemon
  end
end

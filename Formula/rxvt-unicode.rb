class RxvtUnicode < Formula
  desc "Rxvt fork with Unicode support"
  homepage "http://software.schmorp.de/pkg/rxvt-unicode.html"
  url "http://dist.schmorp.de/rxvt-unicode/rxvt-unicode-9.26.tar.bz2"
  sha256 "643116b9a25d29ad29f4890131796d42e6d2d21312282a613ef66c80c5b8c98b"
  license "GPL-3.0-only"

  livecheck do
    url "http://dist.schmorp.de/rxvt-unicode/"
    regex(/href=.*?rxvt-unicode[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "d63da8a963160651a29a24729ff21a071456096706ad59f721b818c322dc889e"
    sha256 big_sur:       "deebaec714d6b276ef8e7c0bdb89f1872b8dd0eab82b97139e1000fc55098ed9"
    sha256 catalina:      "6dbe84073a435ced0c6be3646121374155c2b47df89e76e84d0ebd06ea78a59b"
    sha256 mojave:        "b606c0cc0daa70dc43fad2997af3d11cae5f07d6b5acdd7de0666ce646361876"
  end

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libx11"
  depends_on "libxft"
  depends_on "libxmu"
  depends_on "libxrender"
  depends_on "libxt"

  uses_from_macos "perl"

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

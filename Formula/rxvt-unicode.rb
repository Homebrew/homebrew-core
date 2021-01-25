class RxvtUnicode < Formula
  desc "Rxvt fork with Unicode support"
  homepage "http://software.schmorp.de/pkg/rxvt-unicode.html"
  url "http://dist.schmorp.de/rxvt-unicode/rxvt-unicode-9.22.tar.bz2"
  sha256 "e94628e9bcfa0adb1115d83649f898d6edb4baced44f5d5b769c2eeb8b95addd"
  license "GPL-3.0-only"
  revision 4

  bottle do
    sha256 "db278d2c19f2b837f1fa44dfa4a72bac3ed8c8359a13732fb7db854ba1c6b450" => :big_sur
    sha256 "13dca2d2c2ca7e160e54a6d839b48fb259b4ae719803c0374c186904f3f9ac0e" => :arm64_big_sur
    sha256 "ed894bfefa87992845b652fc3ccf0104b1b4743e2dbdd1f2b7146c73433c165f" => :catalina
    sha256 "6c9e5a04bf611a3e4b342f2554a32db25ef105f5795183bf22512922a1e57a59" => :mojave
    sha256 "e54074cfd9c978a71847abe7af73d5d3c174fc85b4b1a60f254dd831ff5b5714" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libx11"
  depends_on "libxft"
  depends_on "libxmu"
  depends_on "libxrender"
  depends_on "libxt"

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

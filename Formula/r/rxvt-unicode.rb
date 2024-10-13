class RxvtUnicode < Formula
  desc "Rxvt fork with Unicode support"
  homepage "http://software.schmorp.de/pkg/rxvt-unicode.html"
  url "http://dist.schmorp.de/rxvt-unicode/rxvt-unicode-9.31.tar.bz2"
  sha256 "aaa13fcbc149fe0f3f391f933279580f74a96fd312d6ed06b8ff03c2d46672e8"
  license "GPL-3.0-only"
  revision 1

  livecheck do
    url "http://dist.schmorp.de/rxvt-unicode/"
    regex(/href=.*?rxvt-unicode[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "5e4d450d6dfc04b6953bf1899d1d3dbf70b55afba7664cce36b885aafd25b950"
    sha256 arm64_sonoma:   "70b29b652c086003e230952471da39a12032dd80242d86a631b928acc71e37ca"
    sha256 arm64_ventura:  "2f9c19525fe1dbce9500da67db6d0448f2e0e2ee26d66adeb15946ab07c55745"
    sha256 arm64_monterey: "82cee1ad76351a94e29e4d78a9ac8cb6f2931b211536dabe41b1cc25e0a4d0a4"
    sha256 sonoma:         "711146d0e1e926dd067fc33a3a38ae9c1e13b415a573dbbc91ebfa8a0be25f29"
    sha256 ventura:        "613a2d166f0c1e22022a636988c2154515a92647a854d6935e0242036352d413"
    sha256 monterey:       "81910faaa1dc810a5fbc8758f5d9aac32effdab35234a349e1cceb12be7ac75f"
    sha256 x86_64_linux:   "fb67c2eb745d231fa3440147e04b2d3df8ef205a1e0593da2b0620352f6fe182"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxft"
  depends_on "libxmu"
  depends_on "libxrender"

  uses_from_macos "perl"

  on_macos do
    depends_on "libxt"
  end

  resource "libptytty" do
    url "http://dist.schmorp.de/libptytty/libptytty-2.0.tar.gz"
    sha256 "8033ed3aadf28759660d4f11f2d7b030acf2a6890cb0f7926fb0cfa6739d31f7"
  end

  # Patches 1 and 2 remove -arch flags for compiling perl support
  # Patch 3 fixes `make install` target on case-insensitive filesystems
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/rxvt-unicode/9.22.patch"
    sha256 "a266a5776b67420eb24c707674f866cf80a6146aaef6d309721b6ab1edb8c9bb"
  end

  def install
    ENV.cxx11

    resource("libptytty").stage do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: buildpath), "-DBUILD_SHARED_LIBS=OFF"
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", buildpath/"lib/pkgconfig"
    ENV.append "LDFLAGS", "-L#{buildpath}/lib"

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

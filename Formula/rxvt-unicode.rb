class RxvtUnicode < Formula
  desc "Rxvt fork with Unicode support"
  homepage "http://software.schmorp.de/pkg/rxvt-unicode.html"
  url "http://dist.schmorp.de/rxvt-unicode/rxvt-unicode-9.31.tar.bz2"
  sha256 "aaa13fcbc149fe0f3f391f933279580f74a96fd312d6ed06b8ff03c2d46672e8"
  license "GPL-3.0-only"

  livecheck do
    url "http://dist.schmorp.de/rxvt-unicode/"
    regex(/href=.*?rxvt-unicode[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "7dcc677369d1baab6f16df81f8b8eb55ec58e7250c63823105a4b41dfc076012"
    sha256 arm64_monterey: "d7d065eaa8a9edb656446536bc45466062f0c8fd5aba80583bae20c2813b72f2"
    sha256 arm64_big_sur:  "3770fbf0ca91a3f894862c40d27699aa2d602bd5a7420cb3c760c16d98c79f94"
    sha256 ventura:        "de7ffce5e796bac2174392eff67aebcfc19a841e3c10c8e1eb43cf9afb319957"
    sha256 monterey:       "54b0be5c3682b2d6974696b708935ad239ec26117a6028c201f5ca99a701dc90"
    sha256 big_sur:        "ca8c7a88bdb67f56ea721039077450a4f4ceac8f5ea83518bca596f8daedecd5"
    sha256 x86_64_linux:   "69f31db1144e72a56e1453390170053d38fdfcba1d359e6a34c88ff1842cf749"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libx11"
  depends_on "libxft"
  depends_on "libxmu"
  depends_on "libxrender"
  depends_on "libxt"

  uses_from_macos "perl"

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

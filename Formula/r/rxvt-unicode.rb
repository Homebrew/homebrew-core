class RxvtUnicode < Formula
  desc "Rxvt fork with Unicode support"
  homepage "https://software.schmorp.de/pkg/rxvt-unicode.html"
  url "https://dist.schmorp.de/rxvt-unicode/rxvt-unicode-9.31.tar.bz2"
  sha256 "aaa13fcbc149fe0f3f391f933279580f74a96fd312d6ed06b8ff03c2d46672e8"
  license "GPL-3.0-only"
  revision 3

  livecheck do
    url "https://dist.schmorp.de/rxvt-unicode/"
    regex(/href=.*?rxvt-unicode[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "56d89c32e8e8c8f37ef87d5dace2009efe51caf13d1d6abb0e61ddf0b68d19a6"
    sha256 arm64_sequoia: "3f1ae6eddce0ba96eefc0b6f984069486e235904b5ff77565d755e7654e92198"
    sha256 arm64_sonoma:  "87ec60045728d140a90b33b37ad993e22c6cd2c6fc4169fdc63bd37083801ece"
    sha256 sonoma:        "fc19a29b28b86e958b45e230e2175aaf179f82ac474ee97faa231cfff8d9d462"
    sha256 arm64_linux:   "3f6b580d76d9d4ba15350626b72a10d86f6d2a87a1c4cdfead5589db7a9a8f21"
    sha256 x86_64_linux:  "d88dcb3ff493d615da34287043c772da7ccecb0bf3d2ee2b6f63d0230d83e987"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

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
    url "https://dist.schmorp.de/libptytty/libptytty-2.0.tar.gz"
    sha256 "8033ed3aadf28759660d4f11f2d7b030acf2a6890cb0f7926fb0cfa6739d31f7"
  end

  # Patches 1 and 2 remove -arch flags for compiling perl support
  # Patch 3 fixes `make install` target on case-insensitive filesystems
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/rxvt-unicode/9.22.patch"
    sha256 "a266a5776b67420eb24c707674f866cf80a6146aaef6d309721b6ab1edb8c9bb"
  end

  def install
    ENV.cxx11

    resource("libptytty").stage do
      system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args(install_prefix: buildpath)
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
    daemon = spawn bin/"urxvtd"
    sleep 5
    sleep 10 if OS.mac? && Hardware::CPU.intel?
    system bin/"urxvtc", "-k"
    Process.wait daemon
  end
end

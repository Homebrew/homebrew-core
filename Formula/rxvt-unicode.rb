class RxvtUnicode < Formula
  desc "Rxvt fork with Unicode support"
  homepage "http://software.schmorp.de/pkg/rxvt-unicode.html"
  url "http://dist.schmorp.de/rxvt-unicode/rxvt-unicode-9.30.tar.bz2"
  sha256 "fe1c93d12f385876457a989fc3ae05c0915d2692efc59289d0f70fabe5b44d2d"
  license "GPL-3.0-only"
  revision 1

  livecheck do
    url "http://dist.schmorp.de/rxvt-unicode/"
    regex(/href=.*?rxvt-unicode[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "3f7bf25606213515d14a794a47fbb9843d7b93a05eebe3c9811e4690964f0d75"
    sha256 arm64_big_sur:  "323e9de530d90736b2e9696191c63a886b917b366587d0e751e323b2c98357f2"
    sha256 monterey:       "eebf1bb059ef21b86b5f78068e8d09177a4ef134357561748c24a06e3315b808"
    sha256 big_sur:        "3b4b6b8748e2a7273c393eb581055acdfcc034c386676d48cc8b2b1ee045bdec"
    sha256 catalina:       "20124df7ce3f99991a32ac808a055f91ab317b4864b27c87ea650c4178352c84"
    sha256 x86_64_linux:   "07c529a6fd59c5e8d73341d78ba945cba0f6a885dd0814aa0a0e66c1aa3e13c8"
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

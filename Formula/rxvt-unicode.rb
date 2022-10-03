class RxvtUnicode < Formula
  desc "Rxvt fork with Unicode support"
  homepage "http://software.schmorp.de/pkg/rxvt-unicode.html"
  url "http://dist.schmorp.de/rxvt-unicode/rxvt-unicode-9.30.tar.bz2"
  sha256 "fe1c93d12f385876457a989fc3ae05c0915d2692efc59289d0f70fabe5b44d2d"
  license "GPL-3.0-only"
  revision 2

  livecheck do
    url "http://dist.schmorp.de/rxvt-unicode/"
    regex(/href=.*?rxvt-unicode[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "4ac854e93851fe31407e5c934336b133c4a76a9d90f38fdd60c39fb3ce455b79"
    sha256 arm64_big_sur:  "fb2e647f7edf6a0afca21b8878bfacaae81d8c763910af3e4e581b194dfe74d8"
    sha256 monterey:       "019c86e65c76bc79004260602ce5e627c767adb928cf201b85ee9ab12ef13c40"
    sha256 big_sur:        "e5ca7e455eba32191fe9ee695ab2517f4dce5af02e98564714e2c5af8ada8c5f"
    sha256 catalina:       "684b8e5786b87ff7bc6b087220f8a82778e75c15eaca521078f24b7d0f6dfee3"
    sha256 x86_64_linux:   "d89215dc54fa3709cbc4c4f597f5535029a725c3aef49a787270f7631edba5dd"
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

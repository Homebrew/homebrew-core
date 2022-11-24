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
    sha256 arm64_ventura:  "0305a3f5ddc47f75893766fab81ec57e2149c103210e2a79b28925a07d458859"
    sha256 arm64_monterey: "8838a2087d57f7a58d7c4f02d325b4b20fc0ff784550b20e6e692bfef8bafd28"
    sha256 arm64_big_sur:  "5050ae72d24db51f608ec3d9230117726c3abb53e6466a169604a0fd1ce9311f"
    sha256 ventura:        "686eedde51ba53d6632664378fccdf1de069c55a7fff363ec9f516d26699feb0"
    sha256 monterey:       "63507e9c56529a990a2b913beb8abc96bcb3f6e83962ae10489f44f05a874d9f"
    sha256 big_sur:        "e97e6531e7ac474d68456590f6f8b08648c6ffbabf81769ea676f3497297c4a8"
    sha256 catalina:       "aa6a7ad56f33a20912520adf56cfa511b461f2f2b8f9dfa9f4c48230e2a12cc9"
    sha256 x86_64_linux:   "441494f9ac8df2e5e718459fd08905004f294198a6396585112b3d66ebda06f1"
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

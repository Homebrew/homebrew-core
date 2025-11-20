class RxvtUnicode < Formula
  desc "Rxvt fork with Unicode support"
  homepage "http://software.schmorp.de/pkg/rxvt-unicode.html"
  url "http://dist.schmorp.de/rxvt-unicode/rxvt-unicode-9.31.tar.bz2"
  sha256 "aaa13fcbc149fe0f3f391f933279580f74a96fd312d6ed06b8ff03c2d46672e8"
  license "GPL-3.0-only"
  revision 2

  livecheck do
    url "http://dist.schmorp.de/rxvt-unicode/"
    regex(/href=.*?rxvt-unicode[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "a71bfc4668e4e340ed591757fec08351dcfd734c86ad295d17c08eea98729ba3"
    sha256 arm64_sequoia: "1d23f1a4c263ebe7df9a0ee2163d6a93c9d4df1cc4263687da4de3851441a4f3"
    sha256 arm64_sonoma:  "9a582a19640cd577067cd9aec10962f9f744853653b514899707d7f1b6264c42"
    sha256 arm64_ventura: "1365ab0e69449f484abd3d5e36015b9c0fd0ea56719b6c31c8aaee2b9224bc3f"
    sha256 sonoma:        "f31d79c1ebbec748afd99a199a574d290db3ec2a41786b541bb84c9379c2855c"
    sha256 ventura:       "cb951ccd032eeda8764b273d19fbf39910b396196ec529f2bd878e5cb1e5100e"
    sha256 arm64_linux:   "6b14c45ce4f277c329389b0f719c5337dfeb5ed6d72e6771d104cbc37481c4de"
    sha256 x86_64_linux:  "f353a397eeca72af4958ccea670c84c4daf6c426c8f9e415c4b32bc4e2c1a545"
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
    url "http://dist.schmorp.de/libptytty/libptytty-2.0.tar.gz"
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

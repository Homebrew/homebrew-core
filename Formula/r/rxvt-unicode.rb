class RxvtUnicode < Formula
  desc "Rxvt fork with Unicode support"
  homepage "https://software.schmorp.de/pkg/rxvt-unicode.html"
  url "https://dist.schmorp.de/rxvt-unicode/rxvt-unicode-9.31.tar.bz2"
  sha256 "aaa13fcbc149fe0f3f391f933279580f74a96fd312d6ed06b8ff03c2d46672e8"
  license "GPL-3.0-only"
  revision 4

  livecheck do
    url "https://dist.schmorp.de/rxvt-unicode/"
    regex(/href=.*?rxvt-unicode[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e4f9b55040a461f3017d12e2582fc0b6860c34ef8f0009685047b6994cfd8ff3"
    sha256 arm64_sequoia: "e6faed2630b784a751f9d66fbcc2da0bc787c6bae2e302bb37824e78ad51ef11"
    sha256 arm64_sonoma:  "3f8197d22312bb97d38faba3b20c2f5130c7d174684fe7306a9053755019a1ce"
    sha256 sonoma:        "dfd46b5f344974ca6f788c07f9c227b155f4812a3e46a7b8c0505e2b9cfc1278"
    sha256 arm64_linux:   "d08cc5bcacab747de54e7c232cdb1e0d85cf4591d0b79fd5442f3aef83ef184b"
    sha256 x86_64_linux:  "b07157e0dc01f637521fce47ee9cdcdbad295f4af457ac8347cfb6366133413b"
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
    file "Patches/rxvt-unicode/9.22.patch"
    type :unofficial
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
    ENV["RXVT_SOCKET"] = testpath/"urxvtd-test"
    daemon = spawn bin/"urxvtd"
    sleep 5
    sleep 10 if OS.mac? && Hardware::CPU.intel?
    system bin/"urxvtc", "-k"
    Process.wait daemon
  end
end

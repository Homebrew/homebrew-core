class RxvtUnicode < Formula
  desc "Rxvt fork with Unicode support"
  homepage "https://software.schmorp.de/pkg/rxvt-unicode.html"
  url "https://dist.schmorp.de/rxvt-unicode/rxvt-unicode-9.32.tar.bz2"
  sha256 "2f81c16bffb16f97c4633032e08a7ef08c000f81eb05853e950febc6c33328dd"
  license "GPL-3.0-only"

  livecheck do
    url "https://dist.schmorp.de/rxvt-unicode/"
    regex(/href=.*?rxvt-unicode[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "95c9f33b6c07894afe1c840447f8f9ef823b78cab62daf16c9c36997dc89faa1"
    sha256 arm64_tahoe:       "f01e13ec624a599fec75704162cc3aca71a2c9f178614479d23f337949a0015b"
    sha256 arm64_sequoia:     "1bca4e20ce69c4bdc1f42fc9a288802358b1f764fb0e381dd96c71c582d6ff74"
    sha256 arm64_linux:       "5fa2f714fd0900e8981eaeca2808c86aee37f8e49c65e1280ebfbb3c3b1f0694"
    sha256 x86_64_linux:      "d83b8e7dc5b2541564707159d1c7e81891623939887d53a7926799936f81bd77"
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

  deny_network_access!

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
    system bin/"urxvtc", "-k"
    Process.wait daemon
  end
end

class Wxwidgets < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.7/wxWidgets-3.1.7.tar.bz2"
  sha256 "3d666e47d86192f085c84089b850c90db7a73a5d26b684b617298d89dce84f19"
  license "wxWindows"
  head "https://github.com/wxWidgets/wxWidgets.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "962e7804d50391f7c06dd28d408e669660b5625224a77274d9c0e6516e29f0ef"
    sha256 cellar: :any,                 arm64_big_sur:  "bf9794b3723a15fcfd233acc428e8fa98dfd01b8577e42ee8147b3871a01d844"
    sha256 cellar: :any,                 monterey:       "db096a4dda3c85512a4e5770d03baaf3f3832850171a147a641c8db1d47dcb8d"
    sha256 cellar: :any,                 big_sur:        "7b040d2ff79caf2c60caa0bdb1ff1146a383e21815ad4cfbdfa0b61cf76d4997"
    sha256 cellar: :any,                 catalina:       "4b68e521f5b54b216e378f5670f8abcae1a55bf82ea6024d6a25952ef77c0d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8f4fb67e72ccc819f46184c342c8d9088b418b64b55591bb0602cb5389ed76b"
  end

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gtk+3"
    depends_on "libsm"
    depends_on "mesa-glu"
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--enable-clipboard",
      "--enable-controls",
      "--enable-dataviewctrl",
      "--enable-display",
      "--enable-dnd",
      "--enable-graphics_ctx",
      "--enable-std_string",
      "--enable-svg",
      "--enable-unicode",
      "--enable-webviewwebkit",
      "--with-expat",
      "--with-libjpeg",
      "--with-libpng",
      "--with-libtiff",
      "--with-opengl",
      "--with-zlib",
      "--disable-precomp-headers",
      # This is the default option, but be explicit
      "--disable-monolithic",
    ]

    if OS.mac?
      # Set with-macosx-version-min to avoid configure defaulting to 10.5
      args << "--with-macosx-version-min=#{MacOS.version}"
      args << "--with-osx_cocoa"
      args << "--with-libiconv"
    end

    system "./configure", *args
    system "make", "install"

    # wx-config should reference the public prefix, not wxwidgets's keg
    # this ensures that Python software trying to locate wxpython headers
    # using wx-config can find both wxwidgets and wxpython headers,
    # which are linked to the same place
    inreplace "#{bin}/wx-config", prefix, HOMEBREW_PREFIX

    # For consistency with the versioned wxwidgets formulae
    bin.install_symlink "#{bin}/wx-config" => "wx-config-#{version.major_minor}"
    (share/"wx"/version.major_minor).install share/"aclocal", share/"bakefile"
  end

  test do
    system bin/"wx-config", "--libs"
  end
end

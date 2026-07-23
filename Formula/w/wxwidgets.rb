class Wxwidgets < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.3.3/wxWidgets-3.3.3.tar.bz2"
  sha256 "0d55c1b9dadb31536c922b846194072aaf608641cd7e314a3b983996d1a30ccd"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  compatibility_version 2
  head "https://github.com/wxWidgets/wxWidgets.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5ddfe1fc453bda4bd65f9bbb028a733e6cb75fe57acb2cb2239d49f1c588031f"
    sha256 cellar: :any, arm64_sequoia: "2acf596951ac6165e4289125ac0c36ecc084929c405e6e3ca4b6e76d96cbad35"
    sha256 cellar: :any, arm64_sonoma:  "98de1755bff45bcd1558ab6978e3e292d405da89e2c0044835dca7e6c1b54323"
    sha256 cellar: :any, sonoma:        "baf4c2220cc478236a4d683b6648100cc9ef0907e5a9f5b54d216bef065549b5"
    sha256 cellar: :any, arm64_linux:   "9f2e05b0cad6b305d65ca845c9f11ffe733bf72b491460ae27aaa145ab54eeed"
    sha256 cellar: :any, x86_64_linux:  "5001a50bcca05750cb776e6732afb68e303d38785f50eeeec6121f982685f8ad"
  end

  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pcre2"
  depends_on "webp"

  uses_from_macos "expat"

  on_linux do
    depends_on "cairo"
    depends_on "fontconfig"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "libsm"
    depends_on "libx11"
    depends_on "libxkbcommon"
    depends_on "libxtst"
    depends_on "libxxf86vm"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "pango"
    depends_on "wayland"
    depends_on "zlib-ng-compat"
  end

  def install
    # Remove all bundled libraries excluding `nanosvg` which isn't available as formula
    %w[catch pcre libwebp].each { |l| rm_r(buildpath/"3rdparty"/l) }
    %w[expat jpeg png tiff zlib].each { |l| rm_r(buildpath/"src"/l) }

    args = [
      "--enable-clipboard",
      "--enable-controls",
      "--enable-dataviewctrl",
      "--enable-display",
      "--enable-dnd",
      "--enable-graphics_ctx",
      "--enable-svg",
      "--enable-webviewwebkit",
      "--with-expat",
      "--with-libjpeg",
      "--with-libpng",
      "--with-libtiff",
      "--with-libwebp",
      "--with-opengl",
      "--with-zlib",
      "--disable-tests",
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

    system "./configure", *args, *std_configure_args
    system "make", "install"

    # wx-config should reference the public prefix, not wxwidgets's keg
    # this ensures that Python software trying to locate wxpython headers
    # using wx-config can find both wxwidgets and wxpython headers,
    # which are linked to the same place
    inreplace bin/"wx-config", prefix, HOMEBREW_PREFIX

    # For consistency with the versioned wxwidgets formulae
    bin.install_symlink bin/"wx-config" => "wx-config-#{version.major_minor}"
    (share/"wx"/version.major_minor).install share/"aclocal", share/"bakefile"
  end

  test do
    system bin/"wx-config", "--libs"
  end
end

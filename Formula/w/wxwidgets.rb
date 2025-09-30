class Wxwidgets < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.3.1/wxWidgets-3.3.1.tar.bz2"
  sha256 "f936c8d694f9c49a367a376f99c751467150a4ed7cbf8f4723ef19b2d2d9998d"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  head "https://github.com/wxWidgets/wxWidgets.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "2e0e49d77a50fae093ba05fbb33dd7e7f85904e41d19d183a0d1d0536259a781"
    sha256 cellar: :any,                 arm64_sequoia: "68e7b48517034aee17f6dd2a01e0bc187eb8bb3134eef1a8e21d1aa1588dccc7"
    sha256 cellar: :any,                 arm64_sonoma:  "5c0ef73e591ab78fd499d70c1c3d2c9c7075235e1d0b58cbdebdce1d9d9e07a3"
    sha256 cellar: :any,                 arm64_ventura: "cbe903ce43449aab311c9bf986bcffb088ce140b92e9d48aaa27029e25710089"
    sha256 cellar: :any,                 sonoma:        "2ccc3efe4545d4427d9d05babebec32412b373922b32a4449c7ac1016ea8fbd2"
    sha256 cellar: :any,                 ventura:       "a75c5640475ea3d3de76bd1a6c94f500bd563424db049572b77b46923a01d14c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbbcc4091bd5549e44971ccd98d3c7b9c331e2b902fb3f4ed63d8045f62a1b73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21d22b573549d66b83d46cc784fcdc3bb092098c0ce12b6c5a5a32700c1beb01"
  end

  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pcre2"
  depends_on "webp"

  uses_from_macos "expat"
  uses_from_macos "zlib"

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
  end

  def install
    # Remove all bundled libraries excluding `nanosvg` which isn't available as formula
    %w[catch pcre libwebp].each { |l| rm_r(buildpath/"3rdparty"/l) }
    %w[expat jpeg png tiff zlib].each { |l| rm_r(buildpath/"src"/l) }

    # Work around removal of AGL in Tahoe
    inreplace "configure", "-framework AGL", ""

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

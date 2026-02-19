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
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "72d2bf524e7e4e0c33cdb821ceccf03a8710ad857dfbcc98ceb425f016af415b"
    sha256 cellar: :any,                 arm64_sequoia: "6bae94c9ead02198570213f13ed879630f115792ca9b59e59c9284f5afb9d3dd"
    sha256 cellar: :any,                 arm64_sonoma:  "ca100b098e25e75595daac3babb90e5dacc00d2a2b008350f1a9039af37517a6"
    sha256 cellar: :any,                 sonoma:        "f87375d970407f1aa0b8ca69bd40d252c3605d41147c5c4eac8788b6cde073d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4d07cfc394598ab8ae828e6ceab4288f088e2e959ac8a47deec7e2a9f762af9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76a1384109bff5d735bf2db4e79410398afd8f6bd648c916bc514261b7d869e7"
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

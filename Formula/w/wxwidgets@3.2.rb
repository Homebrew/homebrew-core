class WxwidgetsAT32 < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.8.1/wxWidgets-3.2.8.1.tar.bz2"
  sha256 "ad0cf6c18815dcf1a6a89ad3c3d21a306cd7b5d99a602f77372ef1d92cb7d756"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }

  livecheck do
    url :stable
    regex(/^v?(3\.2(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "cd33f7af0dcb20beb90aacf4f7d9945e7739c689b31821a69e9eef088ef3bc3b"
    sha256 cellar: :any,                 arm64_sequoia: "c11bad8fce2b1b905e6b9e9dd67738f4576931725e5b15a35efea59f6134cd82"
    sha256 cellar: :any,                 arm64_sonoma:  "df003b80251db48b7a37f47c36fae426ebdbdaf167709eea66cf77b497a14739"
    sha256 cellar: :any,                 arm64_ventura: "bef52303b87c67ce3dc08b5f4493f31e0b00137df6f9bacf8bbd952d37ee6915"
    sha256 cellar: :any,                 sonoma:        "8fc6ebee377f04e35bf3f31b1c03fe7560d5044ad600e85a1250a3c293c5b67a"
    sha256 cellar: :any,                 ventura:       "e9c85776e9917d705f8cd0d6eae928baca1afcf9c603b9b8ab5ce1dd049952c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "010072339b9063e6a92be9001c330606dfe520e9671a7c9f4dba0582532241b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be9ecb99906f780193393b15622fb1fe5d13b941dbbfe4676d0a8a7750d9957a"
  end

  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pcre2"

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
    %w[catch pcre].each { |l| rm_r(buildpath/"3rdparty"/l) }
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

    # Move some files out of the way to prevent conflict with `wxwidgets`
    (bin/"wxrc").unlink
    bin.install bin/"wx-config" => "wx-config-#{version.major_minor}"
    (share/"wx"/version.major_minor).install share/"aclocal", share/"bakefile"
  end

  def caveats
    <<~EOS
      To avoid conflicts with the wxwidgets formula, `wx-config` and `wxrc`
      have been installed as `wx-config-#{version.major_minor}` and `wxrc-#{version.major_minor}`.
    EOS
  end

  test do
    system bin/"wx-config-#{version.major_minor}", "--libs"
  end
end

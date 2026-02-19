class WxwidgetsAT32 < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.9/wxWidgets-3.2.9.tar.bz2"
  sha256 "fb90f9538bffd6a02edbf80037a0c14c2baf9f509feac8f76ab2a5e4321f112b"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }

  livecheck do
    url :stable
    regex(/^v?(3\.2(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "def241df0ed45b686ecede437f05914fc118411adfc4cef1f5e39dfc2b455b4a"
    sha256 cellar: :any,                 arm64_sequoia: "fddafc373a90a222d5da80c8cab4ccb0ebd66a3d80cc9d5b91c792a384a9c086"
    sha256 cellar: :any,                 arm64_sonoma:  "7ee82e1e66b3e3b8c83a69db5665ca824398883057d2d1ad564cc52b4515ec81"
    sha256 cellar: :any,                 sonoma:        "e91475236162815043f5d88b3eec56df9b1d76fd4187d1e77d68e9ace2e0f8f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57c5ea5d0c19561f052695d2100708e071a8d8eeddf8f697179d2d900b9c1b1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a917897d830f7bb5d489f2b560abe255fe03efd846760a7dfed916c595ea20e"
  end

  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pcre2"

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
    %w[catch pcre].each { |l| rm_r(buildpath/"3rdparty"/l) }
    %w[expat jpeg png tiff zlib].each { |l| rm_r(buildpath/"src"/l) }

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

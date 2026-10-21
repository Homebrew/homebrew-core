class Wxwidgets < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.3.4/wxWidgets-3.3.4.tar.bz2"
  sha256 "815c16cafa4fcbfcf25c5c0a3418309c62257b8a3b6f91d85a1367a134f98c98"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  compatibility_version 3
  head "https://github.com/wxWidgets/wxWidgets.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0f554fde69b6abacfc3c6ed0f39611c9419295d8f6e19933300fe7028ee9359b"
    sha256 cellar: :any, arm64_tahoe:       "a35d29c7870c3fe42f0f2688cd8c9d815db1887df164f16b52086ea44bbba1bc"
    sha256 cellar: :any, arm64_sequoia:     "1244fb20ec6bd39217ad73118995696761a776f66a47f8f38761f0eb29d83892"
    sha256 cellar: :any, arm64_linux:       "fa20fca19dae32d7e923c8088618dce8e4edfb32ff8b9cfb9cd2a24fb7fc94dc"
    sha256 cellar: :any, x86_64_linux:      "07a9b1f8587df1e98500cda649aea6f035894619fcf61f089749da6d805872d3"
  end

  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pcre2"
  depends_on "webp"

  uses_from_macos "expat"

  on_linux do
    depends_on "at-spi2-core"
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

  # Restore public `wxRibbonBar::AcceptsFocus()` for wxPython
  patch do
    url "https://github.com/wxWidgets/wxWidgets/commit/056bf3193a97d470d560b782b9f184017aa0593a.patch?full_index=1"
    sha256 "467164bda254b801723fbf131f250b596a1fbced1336abb5f613598559397f4b"
    type :unofficial
    resolves "https://github.com/wxWidgets/wxWidgets/pull/27203"
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
    (testpath/"test.cpp").write <<~CPP
      #include <wx/string.h>
      #include <iostream>

      int main() {
        std::cout << wxString::FromUTF8("homebrew").Upper().ToStdString();
      }
    CPP
    flags = shell_output("#{bin}/wx-config --cxxflags --libs base").split
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    assert_equal "HOMEBREW", shell_output("./test")
  end
end

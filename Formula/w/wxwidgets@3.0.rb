class WxwidgetsAT30 < Formula
  desc "Cross-platform C++ GUI toolkit - Stable Release"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.0.5.1/wxWidgets-3.0.5.1.tar.bz2"
  sha256 "440f6e73cf5afb2cbf9af10cec8da6cdd3d3998d527598a53db87099524ac807"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "535e712315224e6bc4103dc9ad80553bae1e286100650dcf0d12b7f1f8811dbf"
    sha256 cellar: :any,                 arm64_monterey: "192d4777a1ed701f1cbb83fc089d5ab252b5f2114373878bf4afe0640fa061ea"
    sha256 cellar: :any,                 arm64_big_sur:  "856dac13f581c42ae3c176bbb3cb0054809d98b9d085ea97414737c5ddda2e8f"
    sha256 cellar: :any,                 ventura:        "50257d9376ebedfe7fa03c918bda1e337620251e7ddecdae4c937aaa5384d38f"
    sha256 cellar: :any,                 monterey:       "15fa2f6d32e168ea5ce58a030421ebcd06327dabb0e5fa2bc8b39bb3a5e1e3e3"
    sha256 cellar: :any,                 big_sur:        "fbe7fd53da27ade071ea502e90f16a4037fa61d749ff018e3a887da60ea37595"
    sha256 cellar: :any,                 catalina:       "de311d5eddcecb5d75a53f8058471a47def9a7e5c55f104bb6bb996fb6e84374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f58f8970733e21c551874dd7085899a041b886b283dd15f29bf3880237c125e5"
  end

  deprecate! date: "2022-10-12", because: :versioned_formula

  depends_on "jpeg-turbo"
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
      "--enable-webkit",
      "--enable-webview",
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
    inreplace bin/"wx-config", prefix, HOMEBREW_PREFIX

    # Move some files out of the way to prevent conflict with `wxwidgets`
    bin.install bin/"wx-config" => "wx-config-#{version.major_minor}"
    (bin/"wxrc").unlink
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

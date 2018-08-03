class Wxmac < Formula
  desc "Cross-platform C++ GUI toolkit (wxWidgets for macOS)"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.0.4/wxWidgets-3.0.4.tar.bz2"
  sha256 "96157f988d261b7368e5340afa1a0cad943768f35929c22841f62c25b17bf7f0"
  revision 1
  head "https://github.com/wxWidgets/wxWidgets.git"

  bottle do
    cellar :any
    sha256 "32357b2ab1590b209e89c02fd36c54b5378fe79d32e82abc4047ab4fbae2663c" => :high_sierra
    sha256 "666f423fdee434b4e4f91d6035678f658cf149df8077dae01151c0ebe781445a" => :sierra
    sha256 "6acfa572e370c0f9c2f48f89ab8807a42d81726151e8ebddccca48aa634514de" => :el_capitan
  end

  devel do
    url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.1/wxWidgets-3.1.1.tar.bz2"
    sha256 "c925dfe17e8f8b09eb7ea9bfdcfcc13696a3e14e92750effd839f5e10726159e"
  end

  option "with-stl", "use standard C++ classes for everything"
  option "with-static", "build static libraries"

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

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
      "--with-expat",
      "--with-libjpeg",
      "--with-libpng",
      "--with-libtiff",
      "--with-opengl",
      "--with-osx_cocoa",
      "--with-zlib",
      "--disable-precomp-headers",
      # This is the default option, but be explicit
      "--disable-monolithic",
      # Set with-macosx-version-min to avoid configure defaulting to 10.5
      "--with-macosx-version-min=#{MacOS.version}",
    ]

    args << "--enable-stl" if build.with? "stl"
    args << (build.with?("static") ? "--disable-shared" : "--enable-shared")

    system "./configure", *args
    system "make", "install"

    # wx-config should reference the public prefix, not wxmac's keg
    # this ensures that Python software trying to locate wxpython headers
    # using wx-config can find both wxmac and wxpython headers,
    # which are linked to the same place
    inreplace "#{bin}/wx-config", prefix, HOMEBREW_PREFIX
  end

  test do
    system bin/"wx-config", "--libs"
  end
end

class Wxmac < Formula
  desc "wxWidgets, a cross-platform C++ GUI toolkit (for OS X)"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.0/wxWidgets-3.1.0.tar.bz2"
  sha256 "e082460fb6bf14b7dd6e8ac142598d1d3d0b08a7b5ba402fdbf8711da7e66da8"
  head "https://github.com/wxWidgets/wxWidgets.git"

  bottle do
    cellar :any
    sha256 "3cc5a1c0a2c3a94fdc8ba9fc7664d55f936b95964227ab90a5ea19b904b91418" => :el_capitan
    sha256 "61d719f4a7bd53e3105b8bd41bcf291cec122fe7fb2ab5991bbe462fca2b6d43" => :yosemite
    sha256 "9b137f0338358bdce6afc21e94226a09aa32432563a95173f6f050709e5c8f37" => :mavericks
  end

  # Fix Issue: Creating wxComboCtrl without wxTE_PROCESS_ENTER style results in an assert.
  patch do
    url "https://github.com/wxWidgets/wxWidgets/commit/cee3188c1abaa5b222c57b87cc94064e56921db8.patch"
    sha256 "c6503ba36a166c031426be4554b033bae5b0d9da6fabd33c10ffbcb8672a0c2d"
  end

  # Fix Issue: Building under OS X in C++11 mode for i386 architecture (but not amd64) results in an error about narrowing conversion.
  patch do
    url "https://github.com/wxWidgets/wxWidgets/commit/ee486dba32d02c744ae4007940f41a5b24b8c574.patch"
    sha256 "88ef4c5ec0422d00ae01aff18143216d1e20608f37090be7f18e924c631ab678"
  end

  # Fix Issue: Building under OS X in C++11 results in several -Winconsistent-missing-override warnings.
  patch do
    url "https://github.com/wxWidgets/wxWidgets/commit/173ecd77c4280e48541c33bdfe499985852935ba.patch"
    sha256 "018fdb6abda38f5d017cffae5925fa4ae8afa9c84912c61e0afd26cd4f7b5473"
  end

  option :universal
  option "with-stl", "use standard C++ classes for everything"
  option "with-static", "build static libraries"

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  def install
    # need to set with-macosx-version-min to avoid configure defaulting to 10.5
    args = [
      "--disable-debug",
      "--prefix=#{prefix}",
      "--enable-unicode",
      "--enable-std_string",
      "--enable-display",
      "--with-opengl",
      "--with-osx_cocoa",
      "--with-libjpeg",
      "--with-libtiff",
      # Otherwise, even in superenv, the internal libtiff can pick
      # up on a nonuniversal xz and fail
      # https://github.com/Homebrew/homebrew/issues/22732
      "--without-liblzma",
      "--with-libpng",
      "--with-zlib",
      "--enable-dnd",
      "--enable-clipboard",
      "--enable-webkit",
      "--enable-svg",
      # On 64-bit, enabling mediactrl leads to wxconfig trying to pull
      # in a non-existent 64 bit QuickTime framework. This is submitted
      # upstream and will eventually be fixed, but for now...
      MacOS.prefer_64_bit? ? "--disable-mediactrl" : "--enable-mediactrl",
      "--enable-graphics_ctx",
      "--enable-controls",
      "--enable-dataviewctrl",
      "--with-expat",
      "--disable-precomp-headers",
      "--with-macosx-version-min=#{MacOS.version}",
      # This is the default option, but be explicit
      "--disable-monolithic",
    ]

    if build.universal?
      ENV.universal_binary
      args << "--enable-universal_binary=#{Hardware::CPU.universal_archs.join(",")}"
    end

    args << "--enable-stl" if build.with? "stl"

    if build.with? "static"
      args << "--disable-shared"
    else
      args << "--enable-shared"
    end

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

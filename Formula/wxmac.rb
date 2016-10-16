class Wxmac < Formula
  desc "wxWidgets, a cross-platform C++ GUI toolkit (for macOS)"
  homepage "https://www.wxwidgets.org"
  revision 3

  head "https://github.com/wxWidgets/wxWidgets.git"

  stable do
    url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.0.2/wxWidgets-3.0.2.tar.bz2"
    sha256 "346879dc554f3ab8d6da2704f651ecb504a22e9d31c17ef5449b129ed711585d"

    # Patch for wxOSXPrintData, custom paper not applied
    # http://trac.wxwidgets.org/ticket/16959
    patch do
      url "http://trac.wxwidgets.org/raw-attachment/ticket/16959/wxPaperCustomPatch.patch"
      sha256 "391b5c05caa3843de1579294a62918d9e00b2311313ee2ce1c1943cd5a8494b3"
    end

    # Various fixes related to Yosemite. Revisit in next stable release.
    # Please keep an eye on http://trac.wxwidgets.org/ticket/16329 as well
    # Theoretically the above linked patch should still be needed, but it isn't.
    # Try to find out why.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/bbf4995/wxmac/patch-yosemite.diff"
      sha256 "02ab6d044ceab85127cad11f2eba2164e7f3fe5c95d6a863e8231a57d1f87d6f"
    end

    # Remove uncenessary <QuickTime/QuickTime.h> includes
    # Fixes building against Xcode 8 with macOS 10.12 SDK
    # http://trac.wxwidgets.org/changeset/f6a2d1caef5c6d412c84aa900cb0d3990b350938/git-wxWidgets
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/bbf4995/wxmac/patch-quicktime-removal.diff"
      sha256 "ebddf09877b053a6fafbf61ac52e4a7b511489dc8437110f80f00d5d2b5ff885"
    end
  end

  bottle do
    cellar :any
    sha256 "556bfbece3cb414e7a1fe2ca42627fab0ebece199050a67412d03d0cfc3f5fcd" => :sierra
    sha256 "c2cbbf473d8a11330f40d90dff3c38abf992ccb08be4695784ba8fa33cf036be" => :el_capitan
    sha256 "64bdc1c45b41dcdbc9661f6a893dd8262b67dbeef7893a4688a1fcbb1a527d3a" => :yosemite
    sha256 "8194b716a05383f6cca86692bd5a0a46cd4426d725587e2bd3b77f1ce9fd9f8c" => :mavericks
  end

  devel do
    url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.0/wxWidgets-3.1.0.tar.bz2"
    sha256 "e082460fb6bf14b7dd6e8ac142598d1d3d0b08a7b5ba402fdbf8711da7e66da8"

    # Fix Issue: Creating wxComboCtrl without wxTE_PROCESS_ENTER style results in an assert.
    patch do
      url "https://github.com/wxWidgets/wxWidgets/commit/cee3188c1abaa5b222c57b87cc94064e56921db8.patch"
      sha256 "c6503ba36a166c031426be4554b033bae5b0d9da6fabd33c10ffbcb8672a0c2d"
    end

    # Fix Issue: Building under macOS in C++11 mode for i386 architecture (but not amd64) results in an error about narrowing conversion.
    patch do
      url "https://github.com/wxWidgets/wxWidgets/commit/ee486dba32d02c744ae4007940f41a5b24b8c574.patch"
      sha256 "88ef4c5ec0422d00ae01aff18143216d1e20608f37090be7f18e924c631ab678"
    end

    # Fix Issue: Building under macOS in C++11 results in several -Winconsistent-missing-override warnings.
    patch do
      url "https://github.com/wxWidgets/wxWidgets/commit/173ecd77c4280e48541c33bdfe499985852935ba.patch"
      sha256 "018fdb6abda38f5d017cffae5925fa4ae8afa9c84912c61e0afd26cd4f7b5473"
    end
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
      # https://github.com/Homebrew/legacy-homebrew/issues/22732
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

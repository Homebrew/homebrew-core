class Wxmac < Formula
  desc "Cross-platform C++ GUI toolkit (wxWidgets for macOS)"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.0.3.1/wxWidgets-3.0.3.1.tar.bz2"
  sha256 "3164ad6bc5f61c48d2185b39065ddbe44283eb834a5f62beb13f1d0923e366e4"
  revision 1
  head "https://github.com/wxWidgets/wxWidgets.git"

  bottle do
    cellar :any
    sha256 "9766307eb821a254c81002e7318aa89dc2f4cd7a5a09515fce54eb96ae70f898" => :sierra
    sha256 "2e1552eb9bd91dec735b107686b0dfa501e6bc37997d8e1b1faea930783b63ae" => :el_capitan
    sha256 "0a159643c82f3d57e5c10e3755b1e085bbf92cf5fdd1f87e26e8757faa4b40bf" => :yosemite
  end

  devel do
    url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.0/wxWidgets-3.1.0.tar.bz2"
    sha256 "e082460fb6bf14b7dd6e8ac142598d1d3d0b08a7b5ba402fdbf8711da7e66da8"

    # Fix Issue: Creating wxComboCtrl without wxTE_PROCESS_ENTER style results in an assert.
    patch do
      url "https://github.com/wxWidgets/wxWidgets/commit/cee3188c1abaa5b222c57b87cc94064e56921db8.patch?full_index=1"
      sha256 "c2389fcb565ec4d488aed2586da15ec72d7fdb8c614f266f8f936d6e4ea10210"
    end

    # Fix Issue: Building under macOS in C++11 mode for i386 architecture (but not amd64) results in an error about narrowing conversion.
    patch do
      url "https://github.com/wxWidgets/wxWidgets/commit/ee486dba32d02c744ae4007940f41a5b24b8c574.patch?full_index=1"
      sha256 "dd73556b7a91cbfa63e2eafa8bab48ce5308b382d8e26e60b79f61d0520871e3"
    end

    # Fix Issue: Building under macOS in C++11 results in several -Winconsistent-missing-override warnings.
    patch do
      url "https://github.com/wxWidgets/wxWidgets/commit/173ecd77c4280e48541c33bdfe499985852935ba.patch?full_index=1"
      sha256 "200c4fc3e103c7c9aa36ff35335af1a05494bf00a7181b6d6a11f0ffb2e4dc5d"
    end
  end

  option "with-stl", "use standard C++ classes for everything"
  option "with-static", "build static libraries"

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  def install
    args = [
      "--prefix=#{prefix}",
      "--enable-unicode",
      "--enable-std_string",
      "--enable-display",
      "--with-opengl",
      "--with-osx_cocoa",
      "--with-libjpeg",
      "--with-libtiff",
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
      # need to set with-macosx-version-min to avoid configure defaulting to 10.5
      "--with-macosx-version-min=#{MacOS.version}",
      # This is the default option, but be explicit
      "--disable-monolithic",
    ]

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

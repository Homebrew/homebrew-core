class Wxmac < Formula
  desc "Cross-platform C++ GUI toolkit (wxWidgets for macOS)"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.0.3.1/wxWidgets-3.0.3.1.tar.bz2"
  sha256 "3164ad6bc5f61c48d2185b39065ddbe44283eb834a5f62beb13f1d0923e366e4"
  revision 1
  head "https://github.com/wxWidgets/wxWidgets.git"

  bottle do
    cellar :any
    sha256 "fb15ea55d8393fafa1c286485fc8c1da91b3f41d76a234d9766689cfe4635e1e" => :sierra
    sha256 "b26fa72e62558efa45fc89a4cc9cea74845369764e74fffa339b3f9eb6549827" => :el_capitan
    sha256 "591bffb395156566ef3e55a9a8f2c193bdcde8b941d42cc6e6b41833ceeeaba2" => :yosemite
  end

  # Fix compilation on High Sierra
  # https://trac.wxwidgets.org/ticket/17929#ticket
  patch do
    url "https://github.com/wxWidgets/wxWidgets/commit/9a610eadcfe.patch?full_index=1"
    sha256 "b445ddf1331b8ec21790b7e3fe3ac6059a2548002e7cbb9bf22b597baf32e3bf"
  end

  devel do
    url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.0/wxWidgets-3.1.0.tar.bz2"
    sha256 "e082460fb6bf14b7dd6e8ac142598d1d3d0b08a7b5ba402fdbf8711da7e66da8"

    # Creating wxComboCtrl without wxTE_PROCESS_ENTER style results in an assert
    patch do
      url "https://github.com/wxWidgets/wxWidgets/commit/cee3188c1abaa5b222c57b87cc94064e56921db8.patch?full_index=1"
      sha256 "c2389fcb565ec4d488aed2586da15ec72d7fdb8c614f266f8f936d6e4ea10210"
    end

    # Building under macOS in C++11 mode for i386 architecture (but not amd64) results in an error about narrowing conversion
    patch do
      url "https://github.com/wxWidgets/wxWidgets/commit/ee486dba32d02c744ae4007940f41a5b24b8c574.patch?full_index=1"
      sha256 "dd73556b7a91cbfa63e2eafa8bab48ce5308b382d8e26e60b79f61d0520871e3"
    end

    # Building under macOS in C++11 results in several -Winconsistent-missing-override warnings
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
      # Enabling mediactrl leads to wxconfig trying to pull in a non-existent
      # 64-bit QuickTime framework: https://trac.wxwidgets.org/ticket/17639
      "--disable-mediactrl",
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

class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "http://tcpreplay.appneta.com"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.1.1/tcpreplay-4.1.1.tar.gz"
  sha256 "61b916ef91049cad2a9ddc8de6f5e3e3cc5d9998dbb644dc91cf3a798497ffe4"

  bottle do
    cellar :any
    revision 1
    sha256 "03bfe9130780358c6a9d37e8b663f84c0e939b03c5efa87c90985584d95d2cbc" => :el_capitan
    sha256 "26ae99b72e3dc9feb27db71dd1f49de8734aff9debc1ed279c5a359fa5d4fece" => :yosemite
    sha256 "ab0379428462fbdc2653feae2bcc404cf6b6d2129ddf0461019c53794ce87e4f" => :mavericks
  end

  depends_on "libdnet"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --prefix=#{prefix}
      --enable-dynamic-link
    ]

    if MacOS::Xcode.installed?
      args << "--with-macosx-sdk=#{MacOS.sdk.version}"
    else
      # Allows the CLT to be used if Xcode's not available
      # Reported 11 Jul 2016: https://github.com/appneta/tcpreplay/issues/254
      inreplace "configure" do |s|
        s.gsub! /^.*Could not figure out the location of a Mac OS X SDK.*$/,
                "MACOSX_SDK_PATH=\"\""
        s.gsub! " -isysroot $MACOSX_SDK_PATH", ""
      end
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"tcpreplay", "--version"
  end
end

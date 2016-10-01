class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "http://tcpreplay.appneta.com"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.1.1/tcpreplay-4.1.1.tar.gz"
  sha256 "61b916ef91049cad2a9ddc8de6f5e3e3cc5d9998dbb644dc91cf3a798497ffe4"

  bottle do
    cellar :any
    sha256 "ab4bf20934207921bfbe370d620098c7a41aad6722f9bd124591e56294569fe2" => :sierra
    sha256 "bdef98f3c5bfd5daeb2d99c2361ef3be11661c37acf19536ed210b4a2cb5ba89" => :el_capitan
    sha256 "6faba215d8a394c2761476661c5e62cfff8be36068a71e28c8562d2a7da1286b" => :yosemite
    sha256 "fb831dbf6c074d5b1f639a22711428610c8e99c396637f2b2014eadb32953060" => :mavericks
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

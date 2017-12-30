class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "https://downloads.sourceforge.net/project/x3270/x3270/3.6ga4/suite3270-3.6ga4-src.tgz"
  sha256 "3f6b01f957d62e5d958bff68c11ea5873d564152198b2086771db6a789fafc00"

  bottle do
    sha256 "3f86d3b6ca30797911a4e3970f892a9a1cf0cdab5fa98901c941ec37ab0bc8b7" => :high_sierra
    sha256 "055f5aaf6a25dcdb200bb442a04b200bb68450aeaf359b60839abe074d3d655e" => :sierra
    sha256 "716f6d38027e4b07f4466487cb99834215caee088baaec2d3e5124fad3e05b04" => :el_capitan
  end

  option "with-x11", "Include x3270 (X11-based version)"
  option "without-c3270", "Exclude c3270 (curses-based version)"
  option "without-s3270", "Exclude s3270 (displayless version)"
  option "without-tcl3270", "Exclude tcl3270 (integrated with Tcl)"
  option "without-pr3287", "Exclude pr3287 (printer emulation)"

  depends_on :x11 => :optional
  depends_on "openssl"

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-x3270" if build.with? "x11"
    args << "--enable-c3270" if build.with? "c3270"
    args << "--enable-s3270" if build.with? "s3270"
    args << "--enable-tcl3270" if build.with? "tcl3270"
    args << "--enable-pr3287" if build.with? "pr3287"

    system "./configure", *args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    system bin/"c3270", "--version"
  end
end

class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "https://downloads.sourceforge.net/project/x3270/x3270/3.6ga4/suite3270-3.6ga4-src.tgz"
  sha256 "3f6b01f957d62e5d958bff68c11ea5873d564152198b2086771db6a789fafc00"

  bottle do
    rebuild 1
    sha256 "fcb185056300588a933723599dd3142f20829eee764b5c61264451cacfa04586" => :high_sierra
    sha256 "a02bd6ef6daa2fc941c2db69ae51dd5849593df4186b8a8fd0de58527faedcdd" => :sierra
    sha256 "ebd2763771ac4dd5e0675bd70d7877d258f09775721f6c2dfbec6beb07280bb5" => :el_capitan
    sha256 "345e32a6ff0343ff370d7562138da8a3dba3a248e601a5a23ca6a1c7588f76b8" => :yosemite
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

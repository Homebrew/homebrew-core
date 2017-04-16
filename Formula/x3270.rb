class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "https://downloads.sourceforge.net/project/x3270/x3270/3.5ga9/suite3270-3.5ga9-src.tgz"
  sha256 "654756cc1204fd69a861d416d350a0ab3c9cea317173a80b06aca0402a517d3e"

  bottle do
    sha256 "1cd09052ab45a091596bf1be4cc8bab7acbbd8adf0b28f7667590c8b46871230" => :sierra
    sha256 "2bed418e88841d641907b730a260dfcac9394c1c69b24eadcdf32e00570f2c0f" => :el_capitan
    sha256 "897d18de2b85172e751719687710f20b1717293b10dac669d6eb052e08d4b02a" => :yosemite
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

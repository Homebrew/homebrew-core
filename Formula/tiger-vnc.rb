class TigerVnc < Formula
  desc "High-performance, platform-neutral implementation of VNC"
  homepage "https://tigervnc.org/"
  url "https://github.com/TigerVNC/tigervnc/archive/v1.11.0.tar.gz"
  sha256 "3648eca472a92a4e8fe55b27cd397b1bf16bad0b24a3a1988661f44553f5e2c3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 "c8dbfcd58649b918a6929d550d20237b8b19e32cbd27b8854e3780beb1eea22f" => :catalina
    sha256 "adc432e2afc2a1896802ab884bf1a5c8c6d8a54123190a4e5448f5d6f3e220a4" => :mojave
    sha256 "5601b259800423214cf921d139a1516fec0f25102a840013fdad3a794a62b5e2" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "fltk"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "jpeg-turbo"
  depends_on "pixman"
  depends_on :x11

  def install
    turbo = Formula["jpeg-turbo"]
    args = std_cmake_args + %W[
      -DJPEG_INCLUDE_DIR=#{turbo.include}
      -DJPEG_LIBRARY=#{turbo.lib}/libjpeg.dylib
      .
    ]
    system "cmake", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/vncviewer -h 2>&1", 1)
    assert_match "TigerVNC Viewer 64-bit v#{version}", output
  end
end

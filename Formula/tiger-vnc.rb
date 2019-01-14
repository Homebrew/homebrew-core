class TigerVnc < Formula
  desc "High-performance, platform-neutral implementation of VNC"
  homepage "https://tigervnc.org/"
  url "https://github.com/TigerVNC/tigervnc/archive/v1.9.0.tar.gz"
  sha256 "f15ced8500ec56356c3bf271f52e58ed83729118361c7103eab64a618441f740"
  revision 1

  bottle do
    rebuild 1
    sha256 "a048d592b84fae525742e746550892c20319af975bf01b2ca87a975a7abfae86" => :mojave
    sha256 "1040513ec177df5275b41b8b1dda64126a6e88327771803600e5635b2983505f" => :high_sierra
    sha256 "dca94ec794ece0340d127104ad373a185535317b130c96863f69c9a2c00e1ccd" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "fltk"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "jpeg-turbo"
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

class TigerVnc < Formula
  desc "High-performance, platform-neutral implementation of VNC"
  homepage "https://tigervnc.org/"
  url "https://github.com/TigerVNC/tigervnc/archive/v1.9.0.tar.gz"
  sha256 "f15ced8500ec56356c3bf271f52e58ed83729118361c7103eab64a618441f740"
  revision 2

  bottle do
    sha256 "7c26a564ee151b88fb158868a9b1ae154dd14b4d2dc3fd32286c24db9972b6b4" => :catalina
    sha256 "00d679d7a5302a288803e304852d641454270fb61ad86f29468b6628d098766b" => :mojave
    sha256 "8bc6fd944ac4ddb423a0164b2adf3d0733ce0b7461e53835cdf9d8f3ef1a27cf" => :high_sierra
    sha256 "7c5b8f1a5e52f4bb76ef40a3904aaac50f052dbd9661b6429e86f492a120bb02" => :sierra
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

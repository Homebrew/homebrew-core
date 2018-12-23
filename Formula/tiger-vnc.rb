class TigerVnc < Formula
  desc "High-performance, platform-neutral implementation of VNC"
  homepage "https://tigervnc.org/"
  url "https://github.com/TigerVNC/tigervnc/archive/v1.9.0.tar.gz"
  sha256 "f15ced8500ec56356c3bf271f52e58ed83729118361c7103eab64a618441f740"
  revision 1

  bottle do
    sha256 "4ad5a8b50a61a62438621ea836b22da7635a85b71147f4edba7079e840e70792" => :mojave
    sha256 "904d4aa7c63b84d8f4104a8e24616923f9c24718b5b27649fc86903c37a961ec" => :high_sierra
    sha256 "3a880103ebe8542903019c855d9fd12edaa4646d32748af10fb5e6a0e4f57bfc" => :sierra
    sha256 "d510cb87760d8d36e312410d95a49ab30208b63912fc453faeefd39164167373" => :el_capitan
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

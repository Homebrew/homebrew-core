class TigerVnc < Formula
  desc "High-performance, platform-neutral implementation of VNC"
  homepage "http://tigervnc.org/"
  url "https://github.com/TigerVNC/tigervnc/archive/v1.9.0.tar.gz"
  sha256 "f15ced8500ec56356c3bf271f52e58ed83729118361c7103eab64a618441f740"

  bottle do
    sha256 "c7213004df95a5a8faf38d036bd631a59c6dd9227565fee7485624dfc16c62bc" => :high_sierra
    sha256 "427af0dff8bae2e2720f0c6dea41d54de8eb8e5549ae77faab3110a9366858a5" => :sierra
    sha256 "aba36a55571b32322bcd94cffce43eb5760bd54fa2000d68c3b968c2d9f0f161" => :el_capitan
    sha256 "b7def4172a88768e2e84df9931138e13401a81913a644f25a72ab43f7ba1f6ae" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "gnutls" => :recommended
  depends_on "jpeg-turbo"
  depends_on "gettext"
  depends_on "fltk"
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
end

class TigerVnc < Formula
  desc "High-performance, platform-neutral implementation of VNC"
  homepage "https://tigervnc.org/"
  url "https://github.com/TigerVNC/tigervnc/archive/v1.10.1.tar.gz"
  sha256 "19fcc80d7d35dd58115262e53cac87d8903180261d94c2a6b0c19224f50b58c4"

  bottle do
    sha256 "666603d27a9ed626467b787dcee3b5f541176ef13a3ec8e8e16fc8d314a3f1b4" => :catalina
    sha256 "197e51f10b6373b45b4fa6c39821f24984ee9c5c3dd803dc255b1d030f7f97d2" => :mojave
    sha256 "6b29f38cac25323031ec657628a20fe8732583c5c1b4c5930ae7b52e8cf1d256" => :high_sierra
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

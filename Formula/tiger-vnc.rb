class TigerVnc < Formula
  desc "High-performance, platform-neutral implementation of VNC"
  homepage "https://tigervnc.org/"
  url "https://github.com/TigerVNC/tigervnc/archive/v1.12.0.tar.gz"
  sha256 "9ff3f3948f2a4e8cc06ee598ee4b1096beb62094c13e0b1462bff78587bed789"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "109fdbc449f3d9888c9442b95280bf1f3c2b9ac876670a7bb52f1fb0c350e10e"
    sha256 cellar: :any, arm64_monterey: "77eb966db9ec8b43de5c86e21e6626097271d58f7fbd8ccea5d551bfb0e7ddbf"
    sha256 cellar: :any, arm64_big_sur:  "da27b10b7a89f771a6e134b9e81fa5fd49b8f0ffbd545c8e6569644cd0dcfc65"
    sha256 cellar: :any, ventura:        "8de663dc2ccab42a4256b3d3af1bf595f33e5c5dacc809961a54799df0d47103"
    sha256 cellar: :any, monterey:       "13159586d63ec225969612e5d3f3d47eeacdadf7a3df3c930a932f9a95321002"
    sha256 cellar: :any, big_sur:        "168aaa072c658c672b6cf54901d27c603ce09fe4c70d5711f5cd6b4b8927daea"
    sha256 cellar: :any, catalina:       "e703e1d70a8d46b3c20bd58a9c8c4796ec221342413ca3342a2c2ea66cbc221f"
    sha256               x86_64_linux:   "12274cb50da8dca757eb9a53340ffab3c5fc9f126f5d64c977c4b5cb6f87722b"
  end

  depends_on "cmake" => :build
  depends_on "fltk"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "jpeg-turbo"
  depends_on "pixman"

  on_linux do
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxdamage"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxft"
    depends_on "libxi"
    depends_on "libxinerama"
    depends_on "libxrandr"
    depends_on "libxrender"
    depends_on "libxtst"
    depends_on "linux-pam"
  end

  def install
    turbo = Formula["jpeg-turbo"]
    args = std_cmake_args + %W[
      -DJPEG_INCLUDE_DIR=#{turbo.include}
      -DJPEG_LIBRARY=#{turbo.lib}/#{shared_library("libjpeg")}
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

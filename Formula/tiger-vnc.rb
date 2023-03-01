class TigerVnc < Formula
  desc "High-performance, platform-neutral implementation of VNC"
  homepage "https://tigervnc.org/"
  url "https://github.com/TigerVNC/tigervnc/archive/v1.13.1.tar.gz"
  sha256 "b7c5b8ed9e4e2c2f48c7b2c9f21927db345e542243b4be88e066b2daa3d1ae25"
  license "GPL-2.0-or-later"

  # Tags with a 90+ patch are unstable (e.g., the 1.9.90 tag is used for the
  # 1.10.0 beta release) and this regex should only match the stable versions.
  livecheck do
    url :stable
    regex(/^v?(\d+\.\d+\.(?:\d|[1-8]\d+)(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "cb8b5aca83eec23225f23766cb0cfc5eb15299f8aa5eb13a1ced30ac78756b92"
    sha256 cellar: :any, arm64_monterey: "dd5c3cf2007c8391f094063228c15037c86ccda866859452beeb3aa17b142143"
    sha256 cellar: :any, arm64_big_sur:  "8223ea7c979decd76dab24b5c97f2280c83b0ff3fc7d7a834106c548444d5ca1"
    sha256 cellar: :any, ventura:        "20fce5e9746fe220609a75310888d6b115f73b1f9599f5de1583cac6377971c5"
    sha256 cellar: :any, monterey:       "6eb575b793d946fbc46fb67ed5fa534ca58a535d4e0455d18156383bb134296c"
    sha256 cellar: :any, big_sur:        "1070ab53bc2d15a9d79b889cb0f061009c6587bc32e04f5268d0923671191e0a"
    sha256               x86_64_linux:   "da4cc90f405696e72d0ad4e5b78c0a864c0fdc24309a52cf656ceaa944c9168f"
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
    assert_match "TigerVNC Viewer v#{version}", output
  end
end

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
    sha256 cellar: :any, arm64_ventura:  "020433420a88dee43baf6d3f615c599fcfb198af33a1aa7804b558c42d567530"
    sha256 cellar: :any, arm64_monterey: "7736e3193f654d40c55995280d7a1bd065f869fff11780c83b26321fa83cf614"
    sha256 cellar: :any, arm64_big_sur:  "85d05acc79800b9e5ebb4c187480edbb97afb7b54f0990513ca30ab0a0714d7e"
    sha256 cellar: :any, ventura:        "7955a68a220e7823e98620a6f9be3c43e3057ae773388e5612cff6619fd93733"
    sha256 cellar: :any, monterey:       "08a5dc1ad2f983174eda1c31e68bd66f2db1276cdde640df82ec2d2497b1a990"
    sha256 cellar: :any, big_sur:        "d4961d1d80f491537148c9c5f800ada12df1ece76cc017e1ad10403f740055eb"
    sha256               x86_64_linux:   "5d79edb3286b58e516c615f9350576d50737b61fe4aa94809b0eac7dabda978c"
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

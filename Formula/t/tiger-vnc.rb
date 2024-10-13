class TigerVnc < Formula
  desc "High-performance, platform-neutral implementation of VNC"
  homepage "https://tigervnc.org/"
  url "https://github.com/TigerVNC/tigervnc/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "5700f9919802a2f0529cc058b8caded03281cdbf0335581f2dcc7df03f783419"
  license "GPL-2.0-or-later"

  # Tags with a 90+ patch are unstable (e.g., the 1.9.90 tag is used for the
  # 1.10.0 beta release) and this regex should only match the stable versions.
  livecheck do
    url :stable
    regex(/^v?(\d+\.\d+\.(?:\d|[1-8]\d+)(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "eff90f145a651368f9bdbf5a5d1783804b615fe84589c68c569e4f40573c3860"
    sha256 cellar: :any, arm64_sonoma:   "a4d0f2e2ee98e6026a1264f2399ceae66837b3878b48dcfe5ad666cd90ef841c"
    sha256 cellar: :any, arm64_ventura:  "33b103c92fa1d2089d0c49f3266aa3330a7d8d7c4c1b6e1011accd1d018f8032"
    sha256 cellar: :any, arm64_monterey: "daac790f90e2e4d612b5c0aa52e01fdcd2eae3670216babcbaffc6c492553712"
    sha256 cellar: :any, sonoma:         "6e3950d12238592e88708071a4be97b4d50e66f3f70de8f0dbcee447aff82c79"
    sha256 cellar: :any, ventura:        "041a1cfed4716b20799ce552a237c6ba025ce080f0b3d31d72fee8a0ec2b2028"
    sha256 cellar: :any, monterey:       "dc869076e5e92b85fdc6f1e1075fbb7f4719091eb8157892c25a0ee495c893ef"
    sha256               x86_64_linux:   "91194d51191ea03eea1a927148efc052dce585bdbbb0abf5a83652626285e160"
  end

  depends_on "cmake" => :build
  depends_on "fltk"
  depends_on "gettext"
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "jpeg-turbo"
  depends_on "nettle"
  depends_on "pixman"

  uses_from_macos "zlib"

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

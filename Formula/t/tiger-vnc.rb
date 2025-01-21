class TigerVnc < Formula
  desc "High-performance, platform-neutral implementation of VNC"
  homepage "https://tigervnc.org/"
  url "https://github.com/TigerVNC/tigervnc/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "579d0d04eb5b806d240e99a3c756b38936859e6f7db2f4af0d5656cc9a989d7c"
  license "GPL-2.0-or-later"
  revision 1

  # Tags with a 90+ patch are unstable (e.g., the 1.9.90 tag is used for the
  # 1.10.0 beta release) and this regex should only match the stable versions.
  livecheck do
    url :stable
    regex(/^v?(\d+\.\d+\.(?:\d|[1-8]\d+)(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "7bc176a2d61c328fb349c89517136f824ba6a24e8bd1ce2742212b0a72779136"
    sha256 cellar: :any, arm64_sonoma:  "7cf35ae52dae8555f601816857569539b6f4a4567d0430aca2069ffd064afa30"
    sha256 cellar: :any, arm64_ventura: "d3a0850c956e85032de86105e5f41e4b9d0a284ac459325787689f9a0f1620f8"
    sha256 cellar: :any, sonoma:        "0d423088741028380b8ac0e6afb22e83820f8551d6eeea5c46a68c4b04f62c2d"
    sha256 cellar: :any, ventura:       "9276bf7e39d26bd7822f00b894e36a59851d201c60f478d2404636da226736d5"
    sha256               x86_64_linux:  "7387518d8ad605dd07089fdb78ac5894aa3c9c15bd763d80458a3a907e74cba3"
  end

  depends_on "cmake" => :build
  depends_on "fltk@1.3"
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
    args = %W[
      -DJPEG_INCLUDE_DIR=#{turbo.include}
      -DJPEG_LIBRARY=#{turbo.lib}/#{shared_library("libjpeg")}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/vncviewer -h 2>&1", 1)
    assert_match "TigerVNC Viewer v#{version}", output
  end
end

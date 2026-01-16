class TigerVnc < Formula
  desc "High-performance, platform-neutral implementation of VNC"
  homepage "https://tigervnc.org/"
  url "https://github.com/TigerVNC/tigervnc/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "7f231906801e89f09a212e86701f3df1722e36767d6055a4e619390570548537"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bc4e4b2999680e43b53573d900ea230aaa943be9b2ad109c8875b50b662eabfe"
    sha256 cellar: :any, arm64_sequoia: "a5283ed63187173fe553e5beca0be9171e20bb26be778af47f232df26376cf0e"
    sha256 cellar: :any, arm64_sonoma:  "b74a31a13cf7229b1624f299e64b6c7ac7a1e94b4fd952b8cfc1266d49e6048b"
    sha256 cellar: :any, arm64_ventura: "c65397dac1671e42fdbc3df44d242ef44e21fa7671901f9f56e96a88526ab3cf"
    sha256 cellar: :any, sonoma:        "31e91e161513884c41ad3e821d96b2972ac93f3bac5352b56ea94031d5c6b376"
    sha256 cellar: :any, ventura:       "73dc4363e534ffeb8b4370ad23d4cfb6af0cecf6c5cb0e22f44bb6838feb356c"
    sha256               arm64_linux:   "221f90791a23f0b9ed7d13585c582e8ace7dc8afb42c37ff994ae3baa56c3c1f"
    sha256               x86_64_linux:  "a55108da56f37feaa9f9b1f3da1837bae065ac4f4d8bbcbf9de80676c03d205f"
  end

  depends_on "cmake" => :build
  depends_on "fltk@1.3" # fltk 1.4 issue: https://github.com/TigerVNC/tigervnc/issues/1949
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
    assert_match(/TigerVNC [Vv]iewer v#{version}/, output)
  end
end

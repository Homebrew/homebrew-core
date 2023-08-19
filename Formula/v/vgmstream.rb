class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r1866",
      revision: "90adcd5164b36e55ef5dbf7d5fc57ee7446ebc7b"
  version "r1866"
  license "ISC"
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  livecheck do
    url :stable
    regex(/([^"' >]+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b77e8cc9b43a8b08511eca4b8dd4482284946439a1e9979249f1258206e31317"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "214635e19b5b9348ab017565c5aac57e66711edcdd505caa7a16e2ca5d67ec47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0170fe70f66f37b5a1f83c13d399d29aa056307e2acddd49580fabf4d9883367"
    sha256 cellar: :any_skip_relocation, ventura:        "50090ec7cb78d2358952b7727a2f869f811a99c30875e9fc42d4b1ecdc17906e"
    sha256 cellar: :any_skip_relocation, monterey:       "c8443926e226dd067f81ae4aecd0c84297a81784fe48aaa97a39e26806ad4d3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c70a2fc6926e77cb30fcf37d9df5f6d1b701a009eb50728541c3a8dfc58860e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e0fbb97a6f97f14e622039f7a500aca349274622af0857f00616eff60c6d4da"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "jansson"
  depends_on "libao"
  depends_on "libvorbis"
  depends_on "mpg123"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    ENV["LIBRARY_PATH"] = HOMEBREW_PREFIX/"lib"
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_AUDACIOUS:BOOL=OFF", "-DUSE_CELT=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/cli/vgmstream-cli", "build/cli/vgmstream123"
    lib.install "build/src/libvgmstream.a"
  end

  test do
    assert_match "decode", shell_output("#{bin}/vgmstream-cli 2>&1", 1)
  end
end

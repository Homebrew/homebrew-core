class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r1721",
      revision: "f2f0b3f84a9a93fc2623736e738df16a6050901e"
  version "r1721"
  license "ISC"
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/([^"' >]+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0b8177e17308a4f8a185c3b1eba077dd03fd826dcc3cff9bb6354bd6e4b54329"
    sha256 cellar: :any,                 arm64_big_sur:  "1d77b314ec191484a9a6c7c782191be9666bb7ed7fdfaa7c34cb195244457181"
    sha256 cellar: :any,                 monterey:       "485b40895cf228ea7bf4eb9c6e96f5a115548e2b9a2249609797f409e7465d9a"
    sha256 cellar: :any,                 big_sur:        "b808158bbf9ef50acd280853da0f5449bead4e740799449c76c2f7957d54bddd"
    sha256 cellar: :any,                 catalina:       "b584b6efaadefba88b907ebd946cab0f5078f68c6c6e300a93cdc9c366c3b6de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1061e3d73b5a30248dd565a1d6821a4f1956aaa9c061011ad25e0218926c349"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "ffmpeg"
  depends_on "jansson"
  depends_on "libao"
  depends_on "libvorbis"
  depends_on "mpg123"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    ENV["LIBRARY_PATH"] = HOMEBREW_PREFIX/"lib"
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_AUDACIOUS:BOOL=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/cli/vgmstream-cli", "build/cli/vgmstream123"
    lib.install "build/src/libvgmstream.a"
  end

  test do
    assert_match "decode", shell_output("#{bin}/vgmstream-cli 2>&1", 1)
  end
end

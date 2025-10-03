class Zchunk < Formula
  desc "Compressed file format for efficient deltas"
  homepage "https://github.com/zchunk/zchunk"
  url "https://github.com/zchunk/zchunk/archive/refs/tags/1.5.2.tar.gz"
  sha256 "b7346d950fec2e0c72761f2a9148b0ece84574c49076585abf4bebd369cd4c60"
  license "BSD-2-Clause"
  head "https://github.com/zchunk/zchunk.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7ad04cb097008ae33793a2afb1e575888dc864f848e2e83b901b8b521384549a"
    sha256 cellar: :any, arm64_sequoia: "7ba1ba091cf32d2fec41700a1ae975eabc1c3eda4e5684cccb70d243ce83cc9d"
    sha256 cellar: :any, arm64_sonoma:  "d0aa8e360b30d237429b605947e252d638e46c3f722760fbe519c21befa21fb8"
    sha256 cellar: :any, arm64_ventura: "1e582ed4fa32ad63ac2790a6c81eebb1bbc5ab0d0b1b14f942e5f2167206e91e"
    sha256 cellar: :any, sonoma:        "d491778e21bdcece2786642b5e4eba001ad0d81bbcc98b7dc0f36eb904f71493"
    sha256 cellar: :any, ventura:       "974a31be8b1069d4b33ef670f97b2c35a4ad17b6c53e7da68815597fbfe3de46"
    sha256               arm64_linux:   "2e1736d60f357935e2657b2a11f2ac10136d13b9939bfabd4cde4dd296c399c8"
    sha256               x86_64_linux:  "51c196e07700120f8f76042fc6a9b1ace0ad354813985cd5410eed24e01801b9"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "zstd"

  uses_from_macos "curl"

  on_macos do
    depends_on "argp-standalone" => :build
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"zck", test_fixtures("test.png")
    system bin/"unzck", testpath/"test.png.zck"
    assert_equal test_fixtures("test.png").read, (testpath/"test.png").read
  end
end

class Vvdec < Formula
  desc "Fraunhofer Versatile Video Decoder"
  homepage "https://github.com/fraunhoferhhi/vvdec"
  url "https://github.com/fraunhoferhhi/vvdec/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "721a144ac8888ab4fa06a3d11ff6b4e1ecc010f85a214d20f10bbdad61402e51"
  license "BSD-3-Clause-Clear"
  head "https://github.com/fraunhoferhhi/vvdec.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "69ebebefae9eeb8e308cbac249da4ec58b913f23997a3c59795a5c36774c1594"
    sha256 cellar: :any,                 arm64_ventura:  "67bd0a41760c5fe75a5bc3714d6151bc0d8778fa6792a72c9a195a7790a00eee"
    sha256 cellar: :any,                 arm64_monterey: "2204fd5753a9bd17b6e5d0b356b371e31792d1daf9b19fb146218984dc21d166"
    sha256 cellar: :any,                 arm64_big_sur:  "1a68e16ec2d044c33e2906fbfdbd24cedf194d61f5d016e33450c73f648ce6d4"
    sha256 cellar: :any,                 sonoma:         "9b74de2a0934fa27a4cc25463c9db0bd68d42ee1feed9ace0ab2ab89faa6b5fd"
    sha256 cellar: :any,                 ventura:        "47ea16cb9a8ec07452fb12c3384952bb76f56aae93d1fdd5bc7b970358aa48b5"
    sha256 cellar: :any,                 monterey:       "52764dabb590f7c2969b96df227c5071fc59b9acf76385ca5314da8f187db24e"
    sha256 cellar: :any,                 big_sur:        "c5d0aee8f3e95ba3db78a5318051af89dfc0f6781e77b6e712f1d01c5a68f305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33135e9169fe37202ea8a8c113c9fff668f5dcb1e7d8aefdcf8de015df958b6f"
  end

  depends_on "cmake" => :build

  resource("homebrew-test-video") do
    url "https://archive.org/download/testvideo_20230410_202304/test.vvc"
    sha256 "753261009b6472758cde0dee2c004ff712823b43e62ec3734f0f46380bec8e46"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DBUILD_SHARED_LIBS=1",
           "-DVVDEC_INSTALL_VVDECAPP=1",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("homebrew-test-video").stage testpath
    system bin/"vvdecapp", "-b", testpath/"test.vvc", "-o", testpath/"test.yuv"
    assert_predicate testpath/"test.yuv", :exist?
  end
end

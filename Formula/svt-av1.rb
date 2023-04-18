class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v1.4.1/SVT-AV1-v1.4.1.tar.bz2"
  sha256 "0e988582f315fe76c909accf5e7f81b975c5bd2b850ee760d8e9fac297f70b5d"
  license "BSD-3-Clause"
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d75be3e140658a5d2ab77c27e78e111f14cd584e7ec1d30b7805a2d9f42aec8c"
    sha256 cellar: :any,                 arm64_monterey: "0e0ee9c4f03d17f6487d0c0b5a5be6f3ef3a45e1c50aae62d9694f167393c769"
    sha256 cellar: :any,                 arm64_big_sur:  "eb74baee90fedbad232c1f0789f2e41fe92191bfb2d31f68013dede46680d7c5"
    sha256 cellar: :any,                 ventura:        "48e9908bf52601f0bcb3fb72b44723298c7d2777c62a6fa75abf5379d0c287ec"
    sha256 cellar: :any,                 monterey:       "f182fa7fdee1467727e14992c78665225b804197222f435f8831cb0f3bded757"
    sha256 cellar: :any,                 big_sur:        "0d005eb5453a46fc6a78f99795621ee8057c36d528e103a927d3fee3e79839c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d5747728840c895eae0723f4b3d7e64f73d2f5e04b202696963595a0231e5d8"
  end

  depends_on "cmake" => :build

  on_intel do
    depends_on "yasm" => :build
  end

  resource "homebrew-testvideo" do
    url "https://github.com/grusell/svt-av1-homebrew-testdata/raw/main/video_64x64_yuv420p_25frames.yuv"
    sha256 "0c5cc90b079d0d9c1ded1376357d23a9782a704a83e01731f50ccd162e246492"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    testpath.install resource("homebrew-testvideo")
    system "#{bin}/SvtAv1EncApp", "-w", "64", "-h", "64", "-i", "video_64x64_yuv420p_25frames.yuv", "-b", "output.ivf"
    assert_predicate testpath/"output.ivf", :exist?
  end
end

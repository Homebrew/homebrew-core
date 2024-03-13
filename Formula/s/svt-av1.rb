class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v2.0.0/SVT-AV1-v2.0.0.tar.bz2"
  sha256 "f9c076c377e504be15e195db8dd36d91233bc37cb8e82530382f38bc1926df02"
  license "BSD-3-Clause"
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "34144067a65c826588409a61e6385328078b233b4af39168c6d8bae7cd1fb34b"
    sha256 cellar: :any,                 arm64_ventura:  "e37dda753b5d0d957abacefea981301f7ca27d9aa5a9223cfc5d2868ce156bd1"
    sha256 cellar: :any,                 arm64_monterey: "336216729d71e1fde3c53bdcf5d918cd42012d1014b100443b2107413d6a8b4b"
    sha256 cellar: :any,                 sonoma:         "b26b9a7c1b6c8a768d1d96e323451183c1c6dba2a5f4e1a8c610d612a7cc32a8"
    sha256 cellar: :any,                 ventura:        "ede5135ae1eb1b2be429043462621a930df96e1394a42f14a4b412ff39a0e29c"
    sha256 cellar: :any,                 monterey:       "67ff6fb04f7c9fd9c6c78905fbab4226b6c60a604ee91c804d69e0382ad12de4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d2d6f82048c3946364eceb84f6fa0f7b976bada31a86e2bca249b454e5e1121"
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

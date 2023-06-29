class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v1.6.0/SVT-AV1-v1.6.0.tar.bz2"
  sha256 "c6b49111a2d4c5113f1ada0c2f716d94bd4a8db704623d453066826401ecdab5"
  license "BSD-3-Clause"
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "033ba02aa6949267e5bcf75fb463ae615aae03f9540629909e240a4cd27bf328"
    sha256 cellar: :any,                 arm64_monterey: "fbe3e8c21f48e821ede9d9f64a66e7f63491d45df6f9448e08958c4275a6965f"
    sha256 cellar: :any,                 arm64_big_sur:  "74573920761e119604a034d35f578435c5d73ee4e9f85e1f8b35a10123b6c39f"
    sha256 cellar: :any,                 ventura:        "8c02471dea76bd659fb34a416e6a02c5146cf988048da367dc91a8314a42e5be"
    sha256 cellar: :any,                 monterey:       "0cd1ce85fa5b69b5e7cb9ddf7675c12377c3b4a590f17d9c6d46b1138da62c5b"
    sha256 cellar: :any,                 big_sur:        "866b7e02016d0c9e1132feaa23999f5db91417f6343f3f26188d28056702098d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa2ce7bd91872f24240faa36ecbe68f5575b220726b397c54b70ae4aef51ee08"
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

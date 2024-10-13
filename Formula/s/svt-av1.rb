class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v2.2.1/SVT-AV1-v2.2.1.tar.bz2"
  sha256 "3fd002b88816506f84b6d624659be5cbadb4cdf5a11258a5cbc6bfc488c82d01"
  license "BSD-3-Clause"
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b4ebfab3d3697247524c182b84ecdd03df646cb646aa922b7b844ddd9454032f"
    sha256 cellar: :any,                 arm64_sonoma:   "c6286d14ed2e49b1258acc3c3a5f6eb8139ba6cbd99b72f4a9ee33704a7d3db5"
    sha256 cellar: :any,                 arm64_ventura:  "60999334966012dfcd9697d0c9d5ba1659aa4260e061149d9e94272c37721810"
    sha256 cellar: :any,                 arm64_monterey: "37e32b9bd08e1dcb6b1637a2f61fd81723e089f9d8cba24d874396256d9a8ca4"
    sha256 cellar: :any,                 sonoma:         "974fe9df82f74045f99246c1960fd1d2a613a5d5387dc8edc024867a4d64a392"
    sha256 cellar: :any,                 ventura:        "478337cfa8ea15ad1cc8f401f8cad22ca4879e7dfb2f8509f52f2a9f9ee8aba2"
    sha256 cellar: :any,                 monterey:       "fc42a8ac4e250d8e75dd4633285341dbb228de0bc8710cbacccc0cac6fa0f55b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5171551831f7bdb18ecd55525efbc1189ab6f772ccb586ff9ba19d5f0ef6575"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-testvideo" do
      url "https://github.com/grusell/svt-av1-homebrew-testdata/raw/main/video_64x64_yuv420p_25frames.yuv"
      sha256 "0c5cc90b079d0d9c1ded1376357d23a9782a704a83e01731f50ccd162e246492"
    end

    testpath.install resource("homebrew-testvideo")
    system bin/"SvtAv1EncApp", "-w", "64", "-h", "64", "-i", "video_64x64_yuv420p_25frames.yuv", "-b", "output.ivf"
    assert_predicate testpath/"output.ivf", :exist?
  end
end

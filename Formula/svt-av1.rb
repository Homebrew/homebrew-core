class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v1.4.1/SVT-AV1-v1.4.1.tar.bz2"
  sha256 "0e988582f315fe76c909accf5e7f81b975c5bd2b850ee760d8e9fac297f70b5d"
  license "BSD-3-Clause"
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bd12803c092c49c1cc97754b976dd09023e9355ee67db4181b71a3aa6f44d76e"
    sha256 cellar: :any,                 arm64_monterey: "2062bdb9d55a0e622818e7af7cd0df7aea8de4ab676930c29976f8eb0518ea3d"
    sha256 cellar: :any,                 arm64_big_sur:  "82715408dd4fc1175e8221b6d6b4bcae64907aaf3316f34014f1f968069f3e93"
    sha256 cellar: :any,                 ventura:        "69d8786b268cfcbe5906d68cee5d460f50a2a229d113db6874b0c6de890fcf11"
    sha256 cellar: :any,                 monterey:       "d897948f907ee19abc5cb1012e8cb220722a8afa2d8afa806929e0eb53d8fc82"
    sha256 cellar: :any,                 big_sur:        "a6c21d87573727ea1f7aa639d1fe8faeaafc42f491107f6cdb0356d00e99873a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aefea7ea6b5ad9ba1b2510024f6653a868eb416045bf6f40195b8b8a36ec8c50"
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

class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v2.0.0/SVT-AV1-v2.0.0.tar.bz2"
  sha256 "f9c076c377e504be15e195db8dd36d91233bc37cb8e82530382f38bc1926df02"
  license "BSD-3-Clause"
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e1d475eb5a3775d1c8e17ede405656715d1b07d1d9958c6a32c8ebd1d1a05f79"
    sha256 cellar: :any,                 arm64_ventura:  "7a0e031f44671963f0e42f9272c9cbf1ea8e7c6dafbd72d18083a92207fb2039"
    sha256 cellar: :any,                 arm64_monterey: "c20602c0431650f00db8e1caf7c8504cde97328bbab5ccfe303a16fd0a006871"
    sha256 cellar: :any,                 sonoma:         "0b3337c86674e25269ae55e03725c0cb99ec0336a7429a665a808dd2d0ad2f20"
    sha256 cellar: :any,                 ventura:        "d048ff5a4bc867426594102245d5d13b3022d9e1c0ecfa71b4ba498fca9f5c28"
    sha256 cellar: :any,                 monterey:       "8923c2a68ba50020e5ef2e80964f93044b91fe0168ba5030d72d866e7c9b6121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bcca033241e15d32c39a1a0e8f6767da07999e5888e87353a23f39b07562adc"
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

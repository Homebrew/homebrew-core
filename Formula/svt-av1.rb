class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v1.2.0/SVT-AV1-v1.2.0.tar.gz"
  sha256 "57aa48d6602d5f57b857d6eb89bb349e76c7b7aa9a70e681508dd137a0cc274c"
  license "BSD-3-Clause"
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "93ece0ab58a536c5af08a714aadd6c9f71c3ec0b0bbd01a109aef101f8ff4b5b"
    sha256 cellar: :any,                 arm64_big_sur:  "39de4d54b32a234127bb47f23cd6d44240d979a6a7c88d842f576c57eab87721"
    sha256 cellar: :any,                 monterey:       "e6e41ce5ea74abf0274becb65aee5ec47b3544885687b04974f22e52f44f5b94"
    sha256 cellar: :any,                 big_sur:        "69ca769124878485be07a54ffe6f4d77f0afd78278223154061442c58ee9680b"
    sha256 cellar: :any,                 catalina:       "4606c4e84ce463713a0545faf2007bea7d91d6e56879207eb75d74f3b5fd409c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c330226af6cfb7cdc90736434d07630dddb9d006f8f37bdb01827be3525123b4"
  end

  depends_on "cmake" => :build
  depends_on "make" => :build
  depends_on "yasm" => :build

  resource("homebrew-testvideo") do
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

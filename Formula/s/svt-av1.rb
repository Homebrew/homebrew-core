class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v2.3.0/SVT-AV1-v2.3.0.tar.bz2"
  sha256 "f65358499f572a47d6b076dda73681a8162b02c0b619a551bc2d62ead8ee719a"
  license "BSD-3-Clause"
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b7071bcdd49e6f95dbea917544ae580502b0bb3463b509b40a46f4bc76599c35"
    sha256 cellar: :any,                 arm64_sonoma:  "9628c69df64063f970ed2886c0ee331021ddf62bdb240dc4a596c8a269f67341"
    sha256 cellar: :any,                 arm64_ventura: "bb144183d7849c4e6a7621c447d4b7195255d7ab7f374a0cc417f398fd1cfe53"
    sha256 cellar: :any,                 sonoma:        "16d30044c1f93b2e7d1761609049c98d6ae45a2761d20b16646da8988443b4c5"
    sha256 cellar: :any,                 ventura:       "3f61bca9d63853428078901104a73485771985466300c25e8cb5eb68397b86de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2102cd7a9136546cdaa969708b64d162dde990e74ba5caa4ed935b11bea9f616"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build

  def install
    extra_cmake_args = %W[-DCMAKE_INSTALL_RPATH=#{rpath}]

    # Explicitly disable ARM NEON I8MM extension on Apple Silicon: upstream
    # build script attempts to detect CPU features via compiler flags, which
    # are stripped by brew's compiler shim. The M1 chip does not support the
    # I8MM extension (hw.optional.arm.FEAT_I8MM).
    extra_cmake_args << "-DENABLE_NEON_I8MM=OFF" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *extra_cmake_args, *std_cmake_args
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

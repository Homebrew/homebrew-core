class Xeve < Formula
  desc "Very fast Essential Video Encoder, MPEG-5 EVC (Essential Video Coding)"
  homepage "https://github.com/mpeg5/xeve"
  url "https://github.com/mpeg5/xeve/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "5d1249212f431816b4723937c9ec8491b45ee1bb75c0f46692deaf7f59fbf19c"
  license "BSD-3-Clause"
  head "https://github.com/mpeg5/xeve.git", branch: "master"

  # Regex is needed to avoid picking up non-semver tags
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ae721a0dee4271b950f4dc94536210c59262ae7b97d313dcad5438e8fc216052"
    sha256 cellar: :any, arm64_tahoe:       "62a117c6092b511b95c154cce09dcf78a9c00a9dd8a1aee4af8ace139c70422d"
    sha256 cellar: :any, arm64_sequoia:     "7c3263b3051e7960215f1806fa83fc6f4c9e000cdce7be15c6faa11e20b90e17"
    sha256 cellar: :any, arm64_linux:       "b237217af12e381f3018ec96ae4c1dd33fac3f345574f97de8e6699c33c75e72"
    sha256 cellar: :any, x86_64_linux:      "164691cea22b819ce23ca27643b59582a1e64896d0fdaaadbd7793f0ba4740a2"
  end

  depends_on "cmake" => :build

  resource "homebrew-testvideo", :test do
    url "https://github.com/grusell/svt-av1-homebrew-testdata/raw/main/video_64x64_yuv420p_25frames.yuv"
    sha256 "0c5cc90b079d0d9c1ded1376357d23a9782a704a83e01731f50ccd162e246492"
  end

  allow_network_access! :test

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DSET_PROF=MAIN", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    testpath.install resource("homebrew-testvideo")
    system bin/"xeve_app", "-i", "video_64x64_yuv420p_25frames.yuv",
                           "-w", "64", "-h", "64", "--fps", "25", "-o", "out.evc"
    assert_path_exists testpath/"out.evc"
  end
end

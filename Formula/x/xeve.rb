class Xeve < Formula
  desc "Very fast Essential Video Encoder, MPEG-5 EVC (Essential Video Coding)"
  homepage "https://github.com/mpeg5/xeve"
  url "https://github.com/mpeg5/xeve/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "f60950d063f52adf11ed7196c0bbb0503fa107b0e43af06bdc81fecc24f2a62e"
  license "BSD-3-Clause"
  head "https://github.com/mpeg5/xeve.git", branch: "master"

  # Regex is needed to avoid picking up non-semver tags
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "02d50eb774812c81f896a952863c0fc5020ebbe5de0e02e4ab3dc3a22f63fc41"
    sha256 cellar: :any, arm64_tahoe:       "44b12dca1c905206bad549cc2ae8f5244e86ea6b99e87e9b66c7501d39f5cc17"
    sha256 cellar: :any, arm64_sequoia:     "f04c4fcc4d855a6c988631bddd7578be08aae55ff3a6ee1651be21e00f09b8aa"
    sha256 cellar: :any, arm64_sonoma:      "db742a02c29e84b368491699154e3cce243db22e4b85b3bc854a1c705fa084c6"
    sha256 cellar: :any, sonoma:            "ffa7d57d45c941a8dc6560a1d6294f45b9532de3baad331e38811172727f5fcc"
    sha256 cellar: :any, arm64_linux:       "c7e663fa57cef0e0b9611ab16507163f48acb04af0162c50822c264761632083"
    sha256 cellar: :any, x86_64_linux:      "a45a89b45374d6b940c994754b1abbd6fd720a53ff846dd448deb813db0b498f"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DSET_PROF=MAIN", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-testvideo" do
      url "https://github.com/grusell/svt-av1-homebrew-testdata/raw/main/video_64x64_yuv420p_25frames.yuv"
      sha256 "0c5cc90b079d0d9c1ded1376357d23a9782a704a83e01731f50ccd162e246492"
    end

    testpath.install resource("homebrew-testvideo")
    system bin/"xeve_app", "-i", "video_64x64_yuv420p_25frames.yuv",
                           "-w", "64", "-h", "64", "--fps", "25", "-o", "out.evc"
    assert_path_exists testpath/"out.evc"
  end
end

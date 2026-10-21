class Xevd < Formula
  desc "Very fast Essential Video Decoder, MPEG-5 EVC (Essential Video Coding)"
  homepage "https://github.com/mpeg5/xevd"
  url "https://github.com/mpeg5/xevd/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "258d626fbb6c7ea1677b4fb0ffed3eaca2ec312810d6a76f67359fdc16068472"
  license "BSD-3-Clause"
  head "https://github.com/mpeg5/xevd.git", branch: "master"

  # Regex is needed to avoid picking up non-semver tags
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a16754afa6aed4a775342f46366b599c4883094969d484b530cc37a945689fa4"
    sha256 cellar: :any, arm64_tahoe:       "f095092643e78a002de5a4caa2451c8b3ac55c41deae5ef2e310a5c2dd6dcf6f"
    sha256 cellar: :any, arm64_sequoia:     "4ac67dcddedf6b3dfe83ffc9b4d77023ba6610fc26a84826db96e0f4b23a3854"
    sha256 cellar: :any, arm64_linux:       "51e8dd390bf3308f656b1b2a0089c477489056e6b8e005f0aa2637b4e022ec52"
    sha256 cellar: :any, x86_64_linux:      "451d9ba4175b73da5e23187286de2527ddcbceadb8cfd1739a399629838456bd"
  end

  depends_on "cmake" => :build
  depends_on "xeve" => :test

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DSET_PROF=MAIN", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # 10 frames of 64x64 YUV420p, encoded by the sibling encoder to avoid an external bitstream
    (testpath/"in.yuv").binwrite("\x80" * (64 * 64 * 3 / 2 * 10))
    system formula_opt_bin("xeve")/"xeve_app", "-i", "in.yuv", "-w", "64", "-h", "64",
                                               "--fps", "25", "-o", "in.evc"

    system bin/"xevd_app", "-i", "in.evc", "-o", "out.yuv"
    assert_equal (testpath/"in.yuv").size, (testpath/"out.yuv").size
  end
end

class Xevd < Formula
  desc "Very fast Essential Video Decoder, MPEG-5 EVC (Essential Video Coding)"
  homepage "https://github.com/mpeg5/xevd"
  url "https://github.com/mpeg5/xevd/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "febfdb532819bbf36b1b04e74d3ef328ad0f0f2db6224ddb7640fce6bd0014f4"
  license "BSD-3-Clause"
  head "https://github.com/mpeg5/xevd.git", branch: "master"

  # Regex is needed to avoid picking up non-semver tags
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9fd292d6fcda23a7f610aadb4cacabfc9fc3a3db85855da346dc3f55c2f5e76c"
    sha256 cellar: :any, arm64_tahoe:       "a3607cd47a4dc5a7a4bdae2b0e0075f5fabf9346ba96a9704360bf117d577d26"
    sha256 cellar: :any, arm64_sequoia:     "2dc88ec5b07caa74e143a60ea4c44d5e67877f4ed4acf9fab5960f7af12cb30c"
    sha256 cellar: :any, arm64_sonoma:      "dc5e935ded0b6ca5b65fcf1377a775e0c383998e18ce6d649afced42443dbd6a"
    sha256 cellar: :any, arm64_linux:       "f77217acbb30118293715f9ddbcc00d7ccce1839913ae9b3832244ffd39654b5"
    sha256 cellar: :any, x86_64_linux:      "e064fdacc27a21be48844c58260d19cab2af47d35ef6b394df29c54077cdaff9"
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

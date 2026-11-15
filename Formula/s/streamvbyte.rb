class Streamvbyte < Formula
  desc "Fast integer compression in C"
  homepage "https://fast-pack.github.io/streamvbyte/"
  url "https://github.com/fast-pack/streamvbyte/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "838195fd3347c52735f9c44922fb6e2a509fd31db40fdf892b42347548a1fe3a"
  license "Apache-2.0"
  head "https://github.com/fast-pack/streamvbyte.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "03c10418da8dfd646123f4764a6ef8e0a73ccdce992d5b41ccea5da4901737e0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dc1360bb97ba6c24aa88f363917d57d3e5871de85473038aaf14416ecc8e827e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ae894655b86b7fdabd395ad63690fc938afa2610f7f9e493cf52b2b831fc4185"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3551f4fab64322dfb3f0ed6020cf5cf179cd65d1e7a73f3879b88275768b1081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fd4f324d2c87100f49b18bfc3fce64085d63433c4ae6fe16ee75a474d32ee6be"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/example.c"
  end

  test do
    system ENV.cc, pkgshare/"example.c", "-I#{include}", "-L#{lib}", "-lstreamvbyte", "-o", "test"
    system testpath/"test"
  end
end

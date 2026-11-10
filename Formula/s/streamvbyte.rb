class Streamvbyte < Formula
  desc "Fast integer compression in C"
  homepage "https://fast-pack.github.io/streamvbyte/"
  url "https://github.com/fast-pack/streamvbyte/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "b5603f138150b60a165e669f4c53c3ee9176a48a201976812eff8f9cf87b0f02"
  license "Apache-2.0"
  head "https://github.com/fast-pack/streamvbyte.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fec5e86afd20837abdc1364867a34c9f7f7f7ffb862374a703762da93975c351"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "353e3a7f646d910663bb267f54da58b91b7102ea736989d01d48ea806b0c43df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3f13e3e2d0e234232e237c51dbdf439b9df2cab4c2215dada0f985d3198b3cd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3cc0107f479b10da0e5a1a481995105b24ed53d6996bcc320c60844ba62da388"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b280e61ed8af73f55b2ee46913e838a491d0c4d0aeda2ab973666c9daa234796"
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

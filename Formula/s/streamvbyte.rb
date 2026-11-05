class Streamvbyte < Formula
  desc "Fast integer compression in C"
  homepage "https://fast-pack.github.io/streamvbyte/"
  url "https://github.com/fast-pack/streamvbyte/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "81e90202bc80145d54ca1a2402fb8143fc640c4e5f90cde135d71d02860f5635"
  license "Apache-2.0"
  head "https://github.com/fast-pack/streamvbyte.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b46d26e34d316e8f515ee53e2808f72cc5a1f2751229984ba99d7523c876309d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c55aa7cca18b76ffca248ef6ca90dd600052f7afbdcfb2441f34c71647de611a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8ab745415b0a77f45c16d9447b5fc7be9b08ccd594f5fbdb4bbd344b4c3bef60"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "21a5bdc6709cc3f3231c3eace3968832ca5cf33fdc12f736055bb21d17ccf3ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0ef5ae511b45811cd2ac39b5ead7091d7a8b468634c24bc2936acce1bdd270d0"
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

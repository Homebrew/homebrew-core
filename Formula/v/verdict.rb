class Verdict < Formula
  desc "Compute quality functions of 2 and 3-dimensional regions"
  homepage "https://github.com/sandialabs/verdict"
  url "https://github.com/sandialabs/verdict/archive/refs/tags/1.4.5.tar.gz"
  sha256 "8c3ba194894a1b10b0700643363d02514cfdf88109a0c2710c0a32e857b2bde0"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/sandialabs/verdict.git", branch: "master"

  bottle do
    manifest_sha256 "7401160bee540ecbbff5139454d9a83713efcc293ae66ddb26694022c7697f45"
    sha256 cellar: :any, arm64_golden_gate: "35dad742642b6a22b28beb8b6156e2016cdb4acea899f1f1b6104f7d7212e7ae"
    sha256 cellar: :any, arm64_tahoe:       "5596a8cf780e7705d7be4f19bdd46e060a2ebaeea6ee6622b95274df9b107528"
    sha256 cellar: :any, arm64_sequoia:     "2f44e1b14ce7360b4e1d4c81ac0dc63b7465aba1281b40ddd0052ca2b2189079"
    sha256 cellar: :any, arm64_linux:       "17f7d29099e5641747c227962bcc34c9496ceebc804577e7c1d2f6d15c994410"
    sha256 cellar: :any, x86_64_linux:      "7c5924db03993c340bee0e0eb2a8187206c750c7138c9a2fba83446ef4a5b307"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DVERDICT_ENABLE_TESTING=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <verdict.h>
      #include <iostream>

      int main(void)
      {
        double coords[4][3] = { { 0, 0, 0 }, { 1, 0, 0 }, { 0, 1, 0 }, { 0, 0, 1 } };
        std::cout << verdict::tet_inradius(4, coords);
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-lverdict"
    assert_equal "0.211325", shell_output("./test")
  end
end

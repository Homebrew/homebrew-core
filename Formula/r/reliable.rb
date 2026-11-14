class Reliable < Formula
  desc "Simple packet acknowledgement system for UDP-based protocols"
  homepage "https://github.com/mas-bandwidth/reliable"
  url "https://github.com/mas-bandwidth/reliable/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "7c4a0750d64748f69cb1b05ebaf44e3037914b91bab622ac36ac90d0c2c271f5"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5e6aa427352f112d101cf29291e1e464d491d7b68b695ce63c5a71762a72927b"
    sha256 cellar: :any, arm64_tahoe:       "604c34b2a6cc4f5b69da2b80a12b41b6a01a311fe64bd9de79828eeed9c0fcb6"
    sha256 cellar: :any, arm64_sequoia:     "3747f989f895b82cb05df9fa9939b18f5be8c8a2b52181f2152c9ebb09480cf9"
    sha256 cellar: :any, arm64_linux:       "e128dcabb8434aa7cab1d7c4a791f5197eec89babb68463f33c67e5ae2233229"
    sha256 cellar: :any, x86_64_linux:      "85a7638a678c78d60cc660d87013ae3ded0c0124b3d322c327448cd7178c80c8"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <reliable.h>
      #include <stdio.h>

      int main() {
        if (reliable_init() != RELIABLE_OK) {
          return 1;
        }
        printf("%s", RELIABLE_VERSION_FULL);
        reliable_term();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lreliable", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end

class Reliable < Formula
  desc "Simple packet acknowledgement system for UDP-based protocols"
  homepage "https://github.com/mas-bandwidth/reliable"
  url "https://github.com/mas-bandwidth/reliable/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "102627cd8643b97865413053f443cd891134a6d0e1d20ab3939e8b09f5c54356"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d7a281f04f513506a489115e2371cc959085b9f5fc9dd0178d74b7ca3bb4b75f"
    sha256 cellar: :any, arm64_tahoe:       "df00a4bfb41f49f6a1e0860ed99d558fd8d71a10a100252fd348c45624258f90"
    sha256 cellar: :any, arm64_sequoia:     "64fad25a3ff64808ed1136a768113bc38b6d58112dfc116f0c99264e687e64bd"
    sha256 cellar: :any, arm64_linux:       "d66e67af1962b7de165fb6a797f1f741189123d50d5cef2f3153c7b455ef8a8a"
    sha256 cellar: :any, x86_64_linux:      "b767ebac624bc1bc6e9fc7db781c2008e9227f47ec4a57433f006d303851c8a5"
  end

  depends_on "cmake" => :build

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

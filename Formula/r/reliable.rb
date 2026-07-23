class Reliable < Formula
  desc "Simple packet acknowledgement system for UDP-based protocols"
  homepage "https://github.com/mas-bandwidth/reliable"
  url "https://github.com/mas-bandwidth/reliable/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "e4b6f1c4955fb8a26e4d5a051c3f37559c8c86ca925b2519dfcbfa1ed554aa17"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dadd6c3661e948a17dc196ef256a4dd9678bc1f7954253384c21246d643d7f09"
    sha256 cellar: :any, arm64_sequoia: "fea86c1258c66a54c5577e5979ede934a12b80878f142500dee1ad5db82c2824"
    sha256 cellar: :any, arm64_sonoma:  "3df53fec8bbabc8b6963b8c2b8f644ed6d1a4b47fbbfad57e3f008eef9882780"
    sha256 cellar: :any, sonoma:        "d131c5745ffbcc902def36e79c66be175638f94e74c381d7a54b2a9b288f42bc"
    sha256 cellar: :any, arm64_linux:   "a49fef7273157b5255b890ed641f39f3ae72d688ffed5a80b4a261bd8179f99c"
    sha256 cellar: :any, x86_64_linux:  "4aa129c545dc04fc59e68e024d1926bebb995ecb22a70197179b68166fffb015"
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

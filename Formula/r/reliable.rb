class Reliable < Formula
  desc "Simple packet acknowledgement system for UDP-based protocols"
  homepage "https://github.com/mas-bandwidth/reliable"
  url "https://github.com/mas-bandwidth/reliable/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "bcd4e55fc9ea3108d68a30a1a7ecdcf02d0cfe7e6144e4f1a10b06a6e37529b6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "33de1a495c70b39003b955c6736577bd0cc194307b130d125b66d7493d659f89"
    sha256 cellar: :any, arm64_sequoia: "1496ae27dd1b12b80c35d8593e6378e04aa4013c7ac37138bc40ff3f685b2245"
    sha256 cellar: :any, arm64_sonoma:  "23ffd07d79ad3591f5d523ba71178f070cedc31813f864ea5e6f48ead972cc55"
    sha256 cellar: :any, sonoma:        "2f9b8d336656e7602a41912c4abd3fe43a031f4d928f415c72bc7642b9a1ff8e"
    sha256 cellar: :any, arm64_linux:   "72d6c9480ee84402eba3e14e8f8715f544c3d81680828d9a884cbb5d4062aed5"
    sha256 cellar: :any, x86_64_linux:  "a37865bfeb7f7720d46e2b2ecc499b00edfb957fd95838304360a966a8db7add"
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

class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.33.tar.gz"
  sha256 "142959030f7fb5e08774e96682003fc8445b99b32d7b1a56cce7760cebc761ec"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "000c1dbb3759a817da1a6c2da2054dbb4b5f6360c0588884385a2d6d2397dea2"
    sha256 cellar: :any,                 arm64_monterey: "75fd92ac52b5f0f5d5c48cf9a7dad68eed59379d6036361706aa274bf2274795"
    sha256 cellar: :any,                 arm64_big_sur:  "cc80b352e1851cc63fc77ed65d08aac25a681a5336f57368849acf4e8175b5aa"
    sha256 cellar: :any,                 ventura:        "3b6388bf883d07d2fca4b6259bb5366b7b6ed0474059dfa2311c464e18da3ae0"
    sha256 cellar: :any,                 monterey:       "422d3e52bc28b49333b539fd2feb4f0fe1f2bcc17fa05a6b0f9df6de02051dc1"
    sha256 cellar: :any,                 big_sur:        "0c3ffceb4002e3bd11dd4405f1cffee0a13009fc0b654b3f86354af8fd40c37a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9936b90d0f74823cd56d227a6254ea9d2b3201ad5066a3d2290a0ee5583ec624"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build/static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build/static"
    system "cmake", "--install", "build/static"

    system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system "./test"
  end
end

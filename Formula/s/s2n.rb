class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://aws.github.io/s2n-tls/usage-guide/"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.7.9.tar.gz"
  sha256 "bf51b37dd04633bbb9e7fae67c208d33edf5a43785ef85df2fceb758152a5288"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b724eaf9d952a2e904502acd227bb8986e719edcf4c78a1a4e34b0c9c7e3145c"
    sha256 cellar: :any, arm64_sequoia: "5381dfbb4941037f44a181ef5821fd3a5538b66f619530d332f445685fedf0b3"
    sha256 cellar: :any, arm64_sonoma:  "5ceb02e6685501fa644c5cebde2371414f579f07643d2138fec67cc8d5ac7f2c"
    sha256 cellar: :any, arm64_linux:   "c1704644e1f473eb7e2bfbcfc90d41b272958f0aace3fb320e4d2a2fd0c669eb"
    sha256 cellar: :any, x86_64_linux:  "09909b5d63d9ae804e3603d2ae25ac2e849517485c5e6fc8797d54860d55920e"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build_static", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build_static"
    system "cmake", "--install", "build_static"

    system "cmake", "-S", ".", "-B", "build_shared", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system "./test"
  end
end

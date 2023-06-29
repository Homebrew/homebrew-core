class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.46.tar.gz"
  sha256 "d1d01b5b85eafb20923ea1dbbac2363a7428a84dceb4d5d5ffed44379e28ba3e"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0ad4038fa52d543711506e7c6f70e74a924d082b180cdc2ad4820c01086c2269"
    sha256 cellar: :any,                 arm64_monterey: "1fd64674d12a16bc541023a08cd6e624108a6ce7c264aeace2ab2306dda9338b"
    sha256 cellar: :any,                 arm64_big_sur:  "d4c77dce419ed377878b4a7373ad6095ffb8fcc25bbb9c7561e929272c57bfb1"
    sha256 cellar: :any,                 ventura:        "5efc26d7d1932f467854c8bfb10801a217b7a63f6711d857b4c1bb21a22abe01"
    sha256 cellar: :any,                 monterey:       "4cfc36e2a8b3e0e3f58cfd6e6305972dfbd955d666afd9eb1996ab417a13cea3"
    sha256 cellar: :any,                 big_sur:        "0d1b3c0d1cfd24fd3fc62bdc2c37468a03d7d3ca64ee68097ac56e0a2365828f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "171deabe00f114f180bc93e0c082234460855784d1beae1d168b6491759f9871"
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

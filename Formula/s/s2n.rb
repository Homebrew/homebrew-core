class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.4.7.tar.gz"
  sha256 "907b2995d87dedd1fb30a78978b3c10e1604d7a7cfb2d57d7a1763d36d599686"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7a2a0a962e09f056b40bcf0ec33f880a35b1905535fc4e2f4a17120eeff06c5b"
    sha256 cellar: :any,                 arm64_ventura:  "a43a5746bbbb25cba4dc873865616ddb60874b9f0d1facd6daa1964543e54bdc"
    sha256 cellar: :any,                 arm64_monterey: "a64f93aa99e7261f153fba40bfa706ec7636b92150f0f9f48084c3cd5bc5acf2"
    sha256 cellar: :any,                 sonoma:         "08b3592fbe3e05b24c8a56360ee30ec678df09a58b52419a29f9980e5e154315"
    sha256 cellar: :any,                 ventura:        "3264e21f76d35eb89d8928e4551aa5663a13a2bb4a65186b3ec6e969c3a3535c"
    sha256 cellar: :any,                 monterey:       "4cd566a5b3b681da7fd7aba45b7f1a226afb324d2c9e63840d6304f5a3503eec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e365f8111c6085f5aa91914a3b510869697b84be3c60c7da71a2069bfc87cf13"
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

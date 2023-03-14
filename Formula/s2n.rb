class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.39.tar.gz"
  sha256 "7b32b3f61f609a5408f331d3e08c835981a5b8d1298b6ec8e8d6cf24a0a66a0c"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e2d349d4d2c5b9e779ffa140068e3c78fd195469da3f497129a19655033f49cd"
    sha256 cellar: :any,                 arm64_monterey: "529a89f9220dfb8ce310e8742707204e95500c70255884ac960977d6adaf1e38"
    sha256 cellar: :any,                 arm64_big_sur:  "5b6f9f6ad87ed222b002f2ec777872e7e0b2d204e50fdd7b581872dee277871b"
    sha256 cellar: :any,                 ventura:        "e98bc525f046f079c81349fd2add54dceb461fc39a91c1a732f1e1570ca14962"
    sha256 cellar: :any,                 monterey:       "2aa17d92c301caad8a698bf1b12cc03c431879cd11b8e514bc0d37bfd2a5cb60"
    sha256 cellar: :any,                 big_sur:        "67cbc5d400413bf60f7aaccfe5ce759be44e427cd3ca052f1e37518c81389c18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97c634767732f69dfbeee67a8de57c6a5c696d2622810f628fba3a6e3e4436db"
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

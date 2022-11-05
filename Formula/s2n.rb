class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.27.tar.gz"
  sha256 "58dde9979867a3209a19098ffcd748a144b2462ec81edca5baf864313ff4f589"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ff393e27029097d655ef3fcf3526d3fd39f1503f8a752619b971fab75f5a0aef"
    sha256 cellar: :any,                 arm64_monterey: "13e9ad6f0a0e6cd508987867032e174414641bfe832ae341eddcd3e83e6c9b35"
    sha256 cellar: :any,                 arm64_big_sur:  "8cd6162ada0a1bd031e9cbc6cc1dbf70165ac89017e71a02914841fb1a8c510e"
    sha256 cellar: :any,                 monterey:       "06bffcdf97170ae57a07330cecb6464a565512287c724fad013af7b838c42aec"
    sha256 cellar: :any,                 big_sur:        "83d897ba37a0f16ddbd288bc913c640b49aabb844e7811a26f78b0cafb7a4c30"
    sha256 cellar: :any,                 catalina:       "6b9d33ad911d98540ee06cda61b3d492b36622c5bf5dc14c897f86bcc5fd6e2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "000c53d9e23a7a6cca1839bc92a0a04ecc00638b9f22f4151a0af32ea2065eb9"
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

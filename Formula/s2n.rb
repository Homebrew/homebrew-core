class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "a2d09943b8c99bbfa4a4352766fac1f81429cf5bdd63e6eeebaac1a77dc2b8a6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d1a65590c41f5c3ec585d12d9777e03b3466b085a98af50bea52a7aa050c4350"
    sha256 cellar: :any, big_sur:       "abb94733725e2704c936d0c6cf2376ff955278470e15591a2b51cf1dca133e6c"
    sha256 cellar: :any, catalina:      "683728531d2c965c8abbb1826112ee297bba3c6c48680f1961b2bf248e0cdc00"
    sha256 cellar: :any, mojave:        "f02a82580fe393b454fb1bb49d12fe82fe03262820c2645593aece85de650789"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON", "-DBUILD_TESTING=OFF"
      system "make"
      system "make", "install"
    end
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
    system "./test"
  end
end

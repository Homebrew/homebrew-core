class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.5.14.tar.gz"
  sha256 "3f65f1eca85a8ac279de204455a3e4940bc6ad4a1df53387d86136bcecde0c08"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "93140bd5c5a1dac1ca24a40eed59d2febf5d279baef622258e0a5adddc3705b8"
    sha256 cellar: :any,                 arm64_sonoma:  "4e4af14da1d7094e581ad27db6cb395d468fd7e01d98ce3a4bdafd0ddde12022"
    sha256 cellar: :any,                 arm64_ventura: "f1bb7e42b009e9af9c17e7b7acd6da516145229f76c785ecaa4a34b0612b1651"
    sha256 cellar: :any,                 sonoma:        "2b3f2f96769443741a07cfaf2b5e076719dcb841036643fedb7e6c4427698c48"
    sha256 cellar: :any,                 ventura:       "bd7ccd7227fb82c11dd4b7598c19e6d60ead56e576dc523a0ad58f235c6675e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58121bd4dac871327b620b5dd006d5877fed129758ae1bd0b4c1714caddf85e9"
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

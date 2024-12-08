class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.5.9.tar.gz"
  sha256 "8a9aa2ba9a25f936e241eaa6bb7e39bc1a097d178c4b255fa36795c0457e3f4e"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "00b3e40ef3eae87579b4ff37d7e6e626dc4a1672f935c5ca5d55fdc2c17f968f"
    sha256 cellar: :any,                 arm64_sonoma:  "acedc4be09cef1b47c114eb155a907074b78b5a2a55b77d5374d3ffae40ebc95"
    sha256 cellar: :any,                 arm64_ventura: "220d35e7b29150b7b75ebe4848f81070dd7ad133ad4aa1a182a0b3ac4f5f8375"
    sha256 cellar: :any,                 sonoma:        "d55a6152c5b68775986e12ff08d12a293c2b230777c02e37fe52fbd9e3999afa"
    sha256 cellar: :any,                 ventura:       "879fb481e42f74f12e273cc8c7cf531d45b4402d3a184e58c21d15c32d7bea82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "452e366b212bfbb62e52380a335d63281069031513d8c34624be8f2388bbccd4"
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

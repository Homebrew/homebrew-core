class Snappy < Formula
  desc "Compression/decompression library aiming for high speed"
  homepage "https://google.github.io/snappy/"
  url "https://github.com/google/snappy/archive/1.1.8.tar.gz"
  sha256 "16b677f07832a612b0836178db7f374e414f94657c138e6993cbfc5dcc58651f"
  license "BSD-3-Clause"
  head "https://github.com/google/snappy.git"

  bottle do
    cellar :any
    sha256 "b15a258346dc93bd5c6900a405ccb2e9e02ebfeb5b16607b340cc6a5a021eba3" => :catalina
    sha256 "e996c3b0dfac02c8cdd06d849db47e853800389ff7d18fa66526d7d51d305589" => :mojave
    sha256 "77276307037cc20bf44c86fef60b1745c1d8f84d6f963332535b34868f5fc2b4" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <assert.h>
      #include <snappy.h>
      #include <string>
      using namespace std;
      using namespace snappy;

      int main()
      {
        string source = "Hello World!";
        string compressed, decompressed;
        Compress(source.data(), source.size(), &compressed);
        Uncompress(compressed.data(), compressed.size(), &decompressed);
        assert(source == decompressed);
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lsnappy", "-o", "test"
    system "./test"
  end
end

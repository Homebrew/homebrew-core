class Snappy < Formula
  desc "Compression/decompression library aiming for high speed"
  homepage "https://google.github.io/snappy/"
  url "https://github.com/google/snappy/archive/1.1.5.tar.gz"
  sha256 "c67d8d23387b1902ceff134af26e401d5412c510adeeabe6bb6b47c106b08e45"
  head "https://github.com/google/snappy.git"

  bottle do
    cellar :any
    sha256 "c0db3b0eb4ca734ce33c312e28a736d8a3ba642a022267060892141e3f6f2bcb" => :sierra
    sha256 "171e6724d109bed4cc95b6a843c2637fa0f5ed301dda5063a89b1353c1282488" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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

    system ENV.cxx, "test.cpp", "-L#{lib}", "-lsnappy", "-o", "test"
    system "./test"
  end
end

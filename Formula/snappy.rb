class Snappy < Formula
  desc "Compression/decompression library aiming for high speed"
  homepage "https://google.github.io/snappy/"
  url "https://github.com/google/snappy/archive/1.1.5.tar.gz"
  sha256 "c67d8d23387b1902ceff134af26e401d5412c510adeeabe6bb6b47c106b08e45"
  head "https://github.com/google/snappy.git"

  bottle do
    cellar :any
    sha256 "d08c9481821fe677c168641ab2bd0bfd71d6dfcb4ece3fd92088d945db1b8f07" => :sierra
    sha256 "2a75b17fb7db744e6236c2fdbcec0fcd411918667174237530e913b76906dba1" => :el_capitan
    sha256 "455aa0bb50317dd87378a2484eab60a92bb256ae9c5bc385df1174c522af83ef" => :yosemite
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

class Snappy < Formula
  desc "Compression/decompression library aiming for high speed"
  homepage "https://google.github.io/snappy/"
  url "https://github.com/google/snappy/archive/1.1.7.tar.gz"
  sha256 "3dfa02e873ff51a11ee02b9ca391807f0c8ea0529a4924afa645fbf97163f9d4"
  revision 1
  head "https://github.com/google/snappy.git"

  bottle do
    cellar :any
    sha256 "27823a31c48fadd654671a82aedaa79695d4cd69ce52860ee58a217a03e63d06" => :high_sierra
    sha256 "76e10c7f7dcb0aa2618ea961cc8201b5700e0ef6144139728586d9c2d45d91b7" => :sierra
    sha256 "5ee06fbe8742f3bb428f2bf789b2645a1c727ca68e69a0647cb67d9d906b888e" => :el_capitan
    sha256 "d8bd1af11a95ab58eacfc3c504ac623702b71d03317b300496fce6ecaee620c0" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  # Upstream PR from 20 Dec 2017 "Fix broken version API"
  patch do
    url "https://github.com/google/snappy/pull/61.patch?full_index=1"
    sha256 "131404e4da2440c83115308f58c91b4a29f4ae93bf841284e0877135d122d7e2"
  end

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

    system ENV.cxx, "test.cpp", "-L#{lib}", "-lsnappy", "-o", "test"
    system "./test"
  end
end

class Snappy < Formula
  desc "Compression/decompression library aiming for high speed"
  homepage "https://google.github.io/snappy/"
  url "https://github.com/google/snappy/archive/1.1.7.tar.gz"
  sha256 "3dfa02e873ff51a11ee02b9ca391807f0c8ea0529a4924afa645fbf97163f9d4"
  revision 1
  head "https://github.com/google/snappy.git"

  bottle do
    cellar :any
    sha256 "8b94b2d804b6d86c76d60f65856964f6dfbe14c8dad56782919273667401bc08" => :mojave
    sha256 "162c90af81dcc8378f642b0b9905c78271ea6a5837199fc671e8948749db41f7" => :high_sierra
    sha256 "39554f2f199def29cfce83c64e220635cac7d3481bf42fba20ba935c674d0dc4" => :sierra
    sha256 "90c4778393606a51788e68dcd7046831a71cc2c95698fe261780e649ac3ce26c" => :el_capitan
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

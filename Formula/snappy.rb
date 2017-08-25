class Snappy < Formula
  desc "Compression/decompression library aiming for high speed"
  homepage "https://google.github.io/snappy/"
  url "https://github.com/google/snappy/archive/1.1.7.tar.gz"
  sha256 "3dfa02e873ff51a11ee02b9ca391807f0c8ea0529a4924afa645fbf97163f9d4"
  head "https://github.com/google/snappy.git"

  bottle do
    cellar :any
    sha256 "b36b34447922cd528aa8170776da33862196659701935708d468001a4688daec" => :sierra
    sha256 "503ce22c869b985c9ca15ca923751227715cbedda401f184892f6614c10b6b41" => :el_capitan
    sha256 "6c4b1694e7aa296c9bb97c52c47a747a27e82d89b5138596ef2d89ce99ddae67" => :yosemite
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

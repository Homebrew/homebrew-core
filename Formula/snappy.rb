class Snappy < Formula
  desc "Compression/decompression library aiming for high speed"
  homepage "https://google.github.io/snappy/"
  url "https://github.com/google/snappy/archive/1.1.10.tar.gz"
  sha256 "49d831bffcc5f3d01482340fe5af59852ca2fe76c3e05df0e67203ebbe0f1d90"
  license "BSD-3-Clause"
  head "https://github.com/google/snappy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ca95915a51bed09a5e70ebb6f253eabe4df5b00e87ebe49aea0124f8bb51bc3c"
    sha256 cellar: :any,                 arm64_monterey: "40cfa23024bcadc5ed04823eb8dea4595ebe8e793d913e3c0074defb8eb9e185"
    sha256 cellar: :any,                 arm64_big_sur:  "a18f25dc10ceffe4f8f0256c6ed9354e22a70069f01fc27013cee8cd7238386d"
    sha256 cellar: :any,                 ventura:        "1e9238c5f3f100b635ca74a17b3441d5f5f9c23007537107340d5397bcbd483d"
    sha256 cellar: :any,                 monterey:       "6c0e72f9f601374a7bfe92a9083e382715dc885015c36fc9081de0c068c5fd33"
    sha256 cellar: :any,                 big_sur:        "14d183eff56f11c0ffdc1394d1fedfaa3cc5ba315e3abe4c21598dfbe9fe25d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73aa76de40ad1ca4f5b03a76180a018aadbc05bda2cde1d4b9030cf56d100f2f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  # Fix issue where Mojave clang fails due to entering a __GNUC__ block
  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause "error: invalid output constraint '=@ccz' in asm"
  end

  # Fix issue where `snappy` setting -fno-rtti causes build issues on `folly`
  # `folly` issue ref: https://github.com/facebook/folly/issues/1583
  patch :DATA

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    # Disable tests/benchmarks used for Snappy development
    args = std_cmake_args + %w[
      -DSNAPPY_BUILD_TESTS=OFF
      -DSNAPPY_BUILD_BENCHMARKS=OFF
    ]

    system "cmake", ".", *args
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON", *args
    system "make", "install"
  end

  test do
    # Force use of Clang on Mojave
    ENV.clang if OS.mac?

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

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 672561e..2f97b73 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -76,10 +76,6 @@ else(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
   # Disable C++ exceptions.
   string(REGEX REPLACE "-fexceptions" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-exceptions")
-
-  # Disable RTTI.
-  string(REGEX REPLACE "-frtti" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
-  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti")
 endif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

 # BUILD_SHARED_LIBS is a standard CMake variable, but we declare it here to make

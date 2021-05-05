class Snappy < Formula
  desc "Compression/decompression library aiming for high speed"
  homepage "https://google.github.io/snappy/"
  url "https://github.com/google/snappy/archive/1.1.9.tar.gz"
  sha256 "75c1fbb3d618dd3a0483bff0e26d0a92b495bbe5059c8b4f1c962b478b6e06e7"
  license "BSD-3-Clause"
  head "https://github.com/google/snappy.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f6d2b583adf7f67e01d6399acfd8960929df9ffeb8fb8a93e4570af4da9b799f"
    sha256 cellar: :any, big_sur:       "b3ebf378db9b345341fc4695d1c6834433bd729a471d60b4f34306823312c464"
    sha256 cellar: :any, catalina:      "b15a258346dc93bd5c6900a405ccb2e9e02ebfeb5b16607b340cc6a5a021eba3"
    sha256 cellar: :any, mojave:        "e996c3b0dfac02c8cdd06d849db47e853800389ff7d18fa66526d7d51d305589"
    sha256 cellar: :any, high_sierra:   "77276307037cc20bf44c86fef60b1745c1d8f84d6f963332535b34868f5fc2b4"
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
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    on_macos do
      ENV.llvm_clang if DevelopmentTools.clang_build_version <= 1100
    end

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
    on_macos { ENV.clang }

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

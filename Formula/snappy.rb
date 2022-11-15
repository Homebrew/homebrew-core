class Snappy < Formula
  desc "Compression/decompression library aiming for high speed"
  homepage "https://google.github.io/snappy/"
  # TODO: Remove `ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib` at rebuild.
  url "https://github.com/google/snappy/archive/1.1.9.tar.gz"
  sha256 "75c1fbb3d618dd3a0483bff0e26d0a92b495bbe5059c8b4f1c962b478b6e06e7"
  license "BSD-3-Clause"
  head "https://github.com/google/snappy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c7d3ceead31da3cbf20393cf83f0a31a67a30c9f0bd3dbb2188683a705798de3"
    sha256 cellar: :any,                 arm64_monterey: "8259999a686e6998350672e5e67425d9b5c3afaa139e14b0ad81aa6ac0b3dfa9"
    sha256 cellar: :any,                 arm64_big_sur:  "19b5a3afc6646dcec7a1803921b44fb5c57b6734fc0e32f025633f14d1da05ec"
    sha256 cellar: :any,                 ventura:        "e861f2e9eeb649811212392d0e0c54f2ae0c23790aa69d0fe91bd74e75bed007"
    sha256 cellar: :any,                 monterey:       "fafb5142d8503a35d03d7db786cbcc44f6c625fefdcfa39a1024d5670c87d56c"
    sha256 cellar: :any,                 big_sur:        "d73fd47c36e1559d49e1c4c4346c754a9d2ff2af9a0bef25631f52763f19f0ef"
    sha256 cellar: :any,                 catalina:       "e62a5ab8aa407d6e7d8ddbecdc66fdd1fb256b87730dfe4abbdf8996b3db2869"
    sha256 cellar: :any,                 mojave:         "b5c89925c1e54ea1e1992d076836092fa754681b373b4834766236abb779cfab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6708c99972bc8ff6d2ad298cf0cd498853d73b45f9ac95a9370fc70b2c59297"
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

  # Fix for build failure. Remove with next release.
  patch do
    on_linux do
      url "https://github.com/google/snappy/commit/0c716d435abe65250100c2caea0e5126ac4e14bd.patch?full_index=1"
      sha256 "12ff7d1182a35298de3287db32ef8581b8ef600efd6d9509fcc894d3d2056c80"
    end
  end

  # Fix issue where `snappy` setting -fno-rtti causes build issues on `folly`
  # `folly` issue ref: https://github.com/facebook/folly/issues/1583
  patch :DATA

  def install
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
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

class Snappy < Formula
  desc "Compression/decompression library aiming for high speed"
  homepage "https://google.github.io/snappy/"
  url "https://github.com/google/snappy/archive/refs/tags/1.2.0.tar.gz"
  sha256 "9b8f10fbb5e3bc112f2e5e64f813cb73faea42ec9c533a5023b5ae08aedef42e"
  license "BSD-3-Clause"
  head "https://github.com/google/snappy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4a20c424a6cab88e165030ce17f347cfcbf27c32b3ef4f03c5622b054510b4a2"
    sha256 cellar: :any,                 arm64_ventura:  "c8bd2d0f2c8812acabf1054836f36b65f05bc423967eea60e2eb0227ebc02d81"
    sha256 cellar: :any,                 arm64_monterey: "c2c8cde9635ba55b3b0f6cb8994b07d157166926fc809bfe5b2d8664898ca84b"
    sha256 cellar: :any,                 sonoma:         "d5541a4d0489d0fb44cd2777c15b3dc0a9e8645cad4756e48dafcf076ce03f84"
    sha256 cellar: :any,                 ventura:        "51b567229c4139ff3cab524055cb8c40e53a63d1d8fe2267916f0ffa61bcd0ed"
    sha256 cellar: :any,                 monterey:       "bf3865f380331ba25729c5856caac0668fcc242e70b4ac768b713ea68018f8ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ae12c0660f75dd132bc44df65b8ee38152f1dae9f616589ae4ca95a2b46eae7"
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

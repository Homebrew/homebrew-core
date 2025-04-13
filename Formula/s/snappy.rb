class Snappy < Formula
  desc "Compression/decompression library aiming for high speed"
  homepage "https://google.github.io/snappy/"
  url "https://github.com/google/snappy/archive/refs/tags/1.2.1.tar.gz"
  sha256 "736aeb64d86566d2236ddffa2865ee5d7a82d26c9016b36218fcc27ea4f09f86"
  license "BSD-3-Clause"
  head "https://github.com/google/snappy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "45275e26a466be03a8a2b81ef27afc862038b220cdf7d8cd63f6ff9f47f18e56"
    sha256 cellar: :any,                 arm64_sonoma:   "2b905dfed7d6c0b44de9c89a79a6aa69824758c2727dcffe95bc6ebef465cf3f"
    sha256 cellar: :any,                 arm64_ventura:  "ca5b33ef7fd245020808bcb339f5b7799a4d4441b50c430c9bdd4eeca6a7d785"
    sha256 cellar: :any,                 arm64_monterey: "a3ad18bfdb378542375074f5f3423bb4972147595ee7b3ec38acd04469bff5db"
    sha256 cellar: :any,                 sonoma:         "4a39b310e4c5a726de262265e14cb0ee219f89c0da0afd19328007d965dba7f8"
    sha256 cellar: :any,                 ventura:        "80fa828013ffa932262d110a351fc4f28f44524cc783d23c15b61328182170ac"
    sha256 cellar: :any,                 monterey:       "e31f618776a2346ae18b6aa8bc035e0edc3c1dbf421498ef13f8b5a1e75fd1be"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "039293445a70911dc94d20f009811e1ae86a0364c2df18f6ff5934586129b4e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c33db20cdc5d828f5f90eb3996f6729a02ebf697bf0a67d28f59feeb24bed42"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

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

    args = %w[
      -DSNAPPY_BUILD_TESTS=OFF
      -DSNAPPY_BUILD_BENCHMARKS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build/static", *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    system "cmake", "--install", "build/static"

    system "cmake", "-S", ".", "-B", "build/shared", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"
  end

  test do
    # Force use of Clang on Mojave
    ENV.clang if OS.mac?

    (testpath/"test.cpp").write <<~CPP
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
    CPP

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

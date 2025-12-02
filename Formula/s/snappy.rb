class Snappy < Formula
  desc "Compression/decompression library aiming for high speed"
  homepage "https://google.github.io/snappy/"
  url "https://github.com/google/snappy/archive/refs/tags/1.2.2.tar.gz"
  sha256 "90f74bc1fbf78a6c56b3c4a082a05103b3a56bb17bca1a27e052ea11723292dc"
  license "BSD-3-Clause"
  head "https://github.com/google/snappy.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e735754860a1b086bf31814117dff6eaee6a1d9f26e8de33ee9d75f1decc770b"
    sha256 cellar: :any,                 arm64_sequoia: "326d8c9a73e0990a43fefe96d2e29355fcd6f42906710017bd1a3baf4401bb33"
    sha256 cellar: :any,                 arm64_sonoma:  "28b0702ed678a35c6d03cb4d91f975e17b3b5af7480418f3c82f46365e55533d"
    sha256 cellar: :any,                 arm64_ventura: "9e4594baee5654ab46bf4542d4e1867c6a6700cc11948ee7f496a7a681a1fd28"
    sha256 cellar: :any,                 sonoma:        "47444cd920b4f3232d1d77f51ead8a18e0a77fb5b154bff7c024bf17d700d273"
    sha256 cellar: :any,                 ventura:       "026d656d0beaf42781437e7fe70012b18eb73f16db024f7e46f35891e2e8a1b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2d7ecfa6475c2ad07a45025ad99940c75bf03c7b3772850d830a3dd571ff09c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "462767a5fd6f73305aa7fd232bc5119e96491ad17222092d8b532fe2616ca24e"
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
index cd71a47..ef040d1 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -51,10 +51,6 @@ if(MSVC)
   string(REGEX REPLACE "/EH[a-z]+" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /EHs-c-")
   add_definitions(-D_HAS_EXCEPTIONS=0)
-
-  # Disable RTTI.
-  string(REGEX REPLACE "/GR" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
-  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /GR-")
 else(MSVC)
   # Use -Wall for clang and gcc.
   if(NOT CMAKE_CXX_FLAGS MATCHES "-Wall")
@@ -81,10 +77,6 @@ else(MSVC)
   # Disable C++ exceptions.
   string(REGEX REPLACE "-fexceptions" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-exceptions")
-
-  # Disable RTTI.
-  string(REGEX REPLACE "-frtti" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
-  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti")
 endif(MSVC)

 # BUILD_SHARED_LIBS is a standard CMake variable, but we declare it here to make

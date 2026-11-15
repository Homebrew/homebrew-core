class Snappy < Formula
  desc "Compression/decompression library aiming for high speed"
  homepage "https://google.github.io/snappy/"
  url "https://github.com/google/snappy/archive/refs/tags/1.3.1.tar.gz"
  sha256 "893f708a0bf4b5529d555ffcee390e940e932fcf90261f682604475a76cd0247"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/google/snappy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7f20ac629eaf9a34a0e4d0e1fe60a933d42ececf3d956988fa8b24916e467c85"
    sha256 cellar: :any, arm64_tahoe:       "11f6a15644bc2dece119e6d0cf912e702ed5355ec706409a57bb8d482ff022b0"
    sha256 cellar: :any, arm64_sequoia:     "0b5ff66b47727b8af0cc62797ff3bd88632be5a6de6d03786a706114d8883488"
    sha256 cellar: :any, arm64_linux:       "10c3b695f1253505788952dcd0fe7fdbb81d6b16e2ae5906ac8bf765aa9de69b"
    sha256 cellar: :any, x86_64_linux:      "0c8c71cc1a07999d9ee6761178c594cae7d7e7519de4cb4f870b76a27210fdf3"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  # Fix issue where `snappy` setting -fno-rtti causes build issues on `folly`
  # `folly` issue ref: https://github.com/facebook/folly/issues/1583
  patch :DATA

  deny_network_access!

  def install
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
index 1cab614..bd065a9 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -57,10 +57,6 @@ if(MSVC)
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /EHs-c-")
   add_definitions(-D_HAS_EXCEPTIONS=0)

-  # Disable RTTI.
-  string(REGEX REPLACE "/GR" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
-  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /GR-")
-
   # Support static MSVC runtime when building static library.
   option(SNAPPY_MSVC_STATIC_RUNTIME "Link to static MSVC runtime (/MT or /MTd)" OFF)
   if(SNAPPY_MSVC_STATIC_RUNTIME)
@@ -101,10 +97,6 @@ else(MSVC)
   # Disable C++ exceptions.
   string(REGEX REPLACE "-fexceptions" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-exceptions")
-
-  # Disable RTTI.
-  string(REGEX REPLACE "-frtti" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
-  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti")
 endif(MSVC)

 # BUILD_SHARED_LIBS is a standard CMake variable, but we declare it here to make

class Stormlib < Formula
  desc "Library for handling Blizzard MPQ archives"
  homepage "http://www.zezula.net/en/mpq/stormlib.html"
  url "https://github.com/ladislav-zezula/StormLib/archive/v9.25.tar.gz"
  sha256 "414ebf1bdd220f3c8bc9eb93c063bb30238b45b2cd6e403d6415e5b71d0c3a40"
  license "MIT"
  head "https://github.com/ladislav-zezula/StormLib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c8d8c8b81d453cfdab7bf15f40009ce93d907d59a1090f88da23b8afaa38a585"
    sha256 cellar: :any,                 arm64_monterey: "20d40a92add2aba2f7c9c0ba95e7656718554c56a5e7fdec3678510ec0898ce9"
    sha256 cellar: :any,                 arm64_big_sur:  "e18783101236a68e4e50770a5b1abccc7d563984e425cfedecb43e352fa2eda1"
    sha256 cellar: :any,                 ventura:        "9b3bd511605a7e36642453e78fbcfb8915a7aa837a8d4c734b4a42e68584de8e"
    sha256 cellar: :any,                 monterey:       "b1fad171023fbb5f9dab315b368350c448257b8a6bde70e33a56c0874f97001b"
    sha256 cellar: :any,                 big_sur:        "c4427158fb46683716b4a8f6e1f6701abda4216010c6acf937dece8209d35f4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0299da7f18c6cd0ba1aab12c13b4b30b5d5ffbeea2d8a942c1a60c384ab73970"
  end

  depends_on "cmake" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # prevents cmake from trying to write to /Library/Frameworks/
  patch :DATA

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <StormLib.h>

      int main(int argc, char *argv[]) {
        printf("%s", STORMLIB_VERSION_STRING);
        return 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c"
    assert_equal version.to_s, shell_output("./test")
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 9cf1050..b33e544 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -340,7 +340,6 @@ if(BUILD_SHARED_LIBS)
     message(STATUS "Linking against dependent libraries dynamically")

     if(APPLE)
-        set_target_properties(${LIBRARY_NAME} PROPERTIES FRAMEWORK true)
         set_target_properties(${LIBRARY_NAME} PROPERTIES LINK_FLAGS "-framework Carbon")
     endif()
     if(UNIX)

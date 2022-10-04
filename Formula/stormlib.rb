class Stormlib < Formula
  desc "Library for handling Blizzard MPQ archives"
  homepage "http://www.zezula.net/en/mpq/stormlib.html"
  url "https://github.com/ladislav-zezula/StormLib/archive/v9.24.tar.gz"
  sha256 "33e43788f53a9f36ff107a501caaa744fd239f38bb5c6d6af2c845b87c8a2ee1"
  license "MIT"
  head "https://github.com/ladislav-zezula/StormLib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e53d414b82a05e0b533e487c2f6af493dc19d76e06c43e43c1fe8da18b18f765"
    sha256 cellar: :any,                 arm64_big_sur:  "16d13a201008b0f6c145e80d28ced76f29af97dfcfce05d1bc2dac84ac0dba33"
    sha256 cellar: :any,                 monterey:       "86406682d4f63e431c8239e885b72410a9b5d25e01e8fe6022f33ed62446aa95"
    sha256 cellar: :any,                 big_sur:        "12177d76e3bac8c67baba52c812a855642e780624d7a75f1e826b10811de35b4"
    sha256 cellar: :any,                 catalina:       "686a27d3793a4a80858f442d1feda9d5880e21e687c152067136b4bb27c6fa50"
    sha256 cellar: :any,                 mojave:         "0270b8a31bf89afd8a81a0b8e36f3a967e196f024a3900fdf24ef5ab1b26a422"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14d33ffa96557afdff6f9b3476005b83c6dbcd51994d0b7fed03d2af0484d263"
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

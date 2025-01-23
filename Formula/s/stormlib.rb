class Stormlib < Formula
  desc "Library for handling Blizzard MPQ archives"
  homepage "http://www.zezula.net/en/mpq/stormlib.html"
  url "https://github.com/ladislav-zezula/StormLib/archive/refs/tags/v9.30.tar.gz"
  sha256 "a709a6b034d206404f5297d85e474371203ff5483639955195d99b737bbf7dfe"
  license "MIT"
  head "https://github.com/ladislav-zezula/StormLib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8b6795782ad6b2795e25bdc5a551043daaa07350632a4832bb6cc1405f4fedf2"
    sha256 cellar: :any,                 arm64_sonoma:  "bb576754765e94f0857c3c2185433e40049c6e27defe7ad2527a72d4c4371db2"
    sha256 cellar: :any,                 arm64_ventura: "b7f557770e52c0f9174dcc39378f37e271039449a9c0440ca1e1ad29bcbdef0f"
    sha256 cellar: :any,                 sonoma:        "18bae47580410061160fd52e508b6fc253ef4a07b8ec47049d29a3ec03706615"
    sha256 cellar: :any,                 ventura:       "7aa4237edb1220fb6bd6176e6d7783b003089d991adb5e321c231871db752088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61ecc0f8d4f072d3009874a20c7cc3419e8e7857a3be60865908880a9f949825"
  end

  depends_on "cmake" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # prevents cmake from trying to write to /Library/Frameworks/
  patch :DATA

  def install
    system "cmake", "-S", ".", "-B", "build/static", *std_cmake_args
    system "cmake", "--build", "build/static"
    system "cmake", "--install", "build/static"

    system "cmake", "-S", ".", "-B", "build/shared", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <StormLib.h>

      int main(int argc, char *argv[]) {
        printf("%s", STORMLIB_VERSION_STRING);
        return 0;
      }
    C
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

class Stormlib < Formula
  desc "Library for handling Blizzard MPQ archives"
  homepage "http://www.zezula.net/en/mpq/stormlib.html"
  url "https://github.com/ladislav-zezula/StormLib/archive/v9.22.tar.gz"
  sha256 "7ed583aae5549ba1abc68a8fc9a642b28323cdf835941bd9b2b549a7b623e53d"
  head "https://github.com/ladislav-zezula/StormLib.git"

  bottle do
    cellar :any
    sha256 "27c5056c5f0001e3a0445b31de2361583b8f19b4fde60658f8075383a82bb7ff" => :catalina
    sha256 "c550620a6b13ac72d11763612582483514156a4ffdb1cf5a602b71ae186cc588" => :mojave
    sha256 "b76d57a2af0971b96c0cc46b3e24078486f732131b6845e92cbd776b4d5c20c7" => :high_sierra
    sha256 "aa27fedf8877032a52c85f9a7a57a94149e9fd2c18f25351fd6a61203e5a797d" => :sierra
    sha256 "71e3d5e94f69c23c8f0d5181b4bc130c3202aa6c99e0e42c4b6508b71be0167a" => :el_capitan
  end

  depends_on "cmake" => :build

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
index 76c6aa9..4fd0a46 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -297,7 +297,6 @@ target_include_directories(${LIBRARY_NAME} PUBLIC src/)
 set_target_properties(${LIBRARY_NAME} PROPERTIES PUBLIC_HEADER "src/StormLib.h;src/StormPort.h")
 if(BUILD_SHARED_LIBS)
     if(APPLE)
-        set_target_properties(${LIBRARY_NAME} PROPERTIES FRAMEWORK true)
         set_target_properties(${LIBRARY_NAME} PROPERTIES LINK_FLAGS "-framework Carbon")
     endif()
     if(UNIX)

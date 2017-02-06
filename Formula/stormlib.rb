class Stormlib < Formula
  desc "Library for handling Blizzard MPQ archives"
  homepage "http://www.zezula.net/en/mpq/stormlib.html"
  url "https://github.com/ladislav-zezula/StormLib/archive/v9.21.tar.gz"
  sha256 "e23e9f106c6367f161fc63e015e7da6156b261b14c7e4a5aa542df02009294f9"
  head "https://github.com/ladislav-zezula/StormLib.git"

  bottle do
    cellar :any
    sha256 "415a6b7424409864d906cf7e2694bff9f3aa6cf03e91e93b75a330df37d602c9" => :sierra
    sha256 "9463671aa577c6054a9598d157eeeff15d1f3c4ef01cf74779ab8e74a0c0a4b8" => :el_capitan
    sha256 "3f35322bf7290615a04f616d274f1228cdcb3d0d825ff0e454ccd78e01870735" => :yosemite
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
    (testpath/"test.c").write <<-EOS.undent
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

class Stormlib < Formula
  desc "Library for handling Blizzard MPQ archives"
  homepage "http://www.zezula.net/en/mpq/stormlib.html"
  url "https://github.com/ladislav-zezula/StormLib/archive/v9.22.tar.gz"
  sha256 "7ed583aae5549ba1abc68a8fc9a642b28323cdf835941bd9b2b549a7b623e53d"
  head "https://github.com/ladislav-zezula/StormLib.git"

  bottle do
    cellar :any
    sha256 "08f7cbb646668dda582913b3a90d04bc2ae6be6b34f6892d268c21a5c4d676a3" => :high_sierra
    sha256 "481d70430ef0cb2e75cf910eccec6fdda777d2613c26cadf0d88dec24480ad2e" => :sierra
    sha256 "daa69abf402a5fe21a8c212423fd053bd2b3e17d09338be75064c5c4c0cd9a20" => :el_capitan
    sha256 "8049593dd7b6c21affd5faa498e3383cdebaab99dd31e54a497a2ad8e4798f06" => :yosemite
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

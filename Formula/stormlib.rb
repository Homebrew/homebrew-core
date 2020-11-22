class Stormlib < Formula
  desc "Library for handling Blizzard MPQ archives"
  homepage "http://www.zezula.net/en/mpq/stormlib.html"
  url "https://github.com/ladislav-zezula/StormLib/archive/v9.23.tar.gz"
  sha256 "d62ba42f1e02efcb2cbaa03bd2e20fbd18c45499ef5fe65ffb89ee52a7bd9c92"
  license "MIT"
  head "https://github.com/ladislav-zezula/StormLib.git"

  bottle do
    cellar :any
    sha256 "09e7a1ac6c2b8b12c07a97e19b39c4f4ca664c91a4c1c286c1bb30c6e0890352" => :big_sur
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
    # remove in the next release
    inreplace "src/StormLib.h", "dwCompressionNext = MPQ_COMPRESSION_NEXT_SAME",
                                  "dwCompressionNext"

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
index bd8d336..927a47d 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -314,7 +314,6 @@ if(BUILD_SHARED_LIBS)
     message(STATUS "Linking against dependent libraries dynamically")

     if(APPLE)
-        set_target_properties(${LIBRARY_NAME} PROPERTIES FRAMEWORK true)
         set_target_properties(${LIBRARY_NAME} PROPERTIES LINK_FLAGS "-framework Carbon")
     endif()
     if(UNIX)
diff --git a/src/StormLib.h b/src/StormLib.h
index f254290..43fefb8 100644
--- a/src/StormLib.h
+++ b/src/StormLib.h
@@ -480,7 +480,9 @@ typedef void (WINAPI * SFILE_ADDFILE_CALLBACK)(void * pvUserData, DWORD dwBytesW
 typedef void (WINAPI * SFILE_COMPACT_CALLBACK)(void * pvUserData, DWORD dwWorkType, ULONGLONG BytesProcessed, ULONGLONG TotalBytes);

 struct TFileStream;
+typedef struct TFileStream TFileStream;
 struct TMPQBits;
+typedef struct TMPQBits TMPQBits;

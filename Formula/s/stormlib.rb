class Stormlib < Formula
  desc "Library for handling Blizzard MPQ archives"
  homepage "http://www.zezula.net/en/mpq/stormlib.html"
  url "https://github.com/ladislav-zezula/StormLib/archive/refs/tags/v9.31.tar.gz"
  sha256 "c8d77e626cc907c8f2d00bb5c48f9d6c70344848d49cab4468f6234afaf815c1"
  license "MIT"
  head "https://github.com/ladislav-zezula/StormLib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "63610ef760e7c3bed0a6611a7801294dc6763ecd43d76f698f1c8ccd1a9f24f7"
    sha256 cellar: :any,                 arm64_sequoia: "36f84767d28782b692fad1e3be42f65527e78fd6015172aadf924f41823b587d"
    sha256 cellar: :any,                 arm64_sonoma:  "0178c3c24eaf5bfbd7b636b12f33d8d2260fc6050d083639eea7ba08cab97467"
    sha256 cellar: :any,                 sonoma:        "e54dfc0899f388dd5680b107b0cb87af0ecb58070f6aaa207969799469371e80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d7459f3505756339ba31dab393c5bb3d828ea94b3461b2b891605e3d10b792d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a65a1853f0206e4b5515783f36e845f2d61b9f97c31251cd61fa78fb1e0bd30b"
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

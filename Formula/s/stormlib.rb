class Stormlib < Formula
  desc "Library for handling Blizzard MPQ archives"
  homepage "http://www.zezula.net/en/mpq/stormlib.html"
  url "https://github.com/ladislav-zezula/StormLib/archive/refs/tags/v9.26.tar.gz"
  sha256 "252efd25430aeba2fea4e0ffd99015c51b3ccedd16efa0c5ec73fd00550d8270"
  license "MIT"
  head "https://github.com/ladislav-zezula/StormLib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "71b6ea1871d9142236d804e01cc8cb579e73451196691d2091cf55f4db03f2a8"
    sha256 cellar: :any,                 arm64_sonoma:   "1df54c64c679ef6d4427541ebeb4b302989d61d5e88ac5a7a8ff86d9799f54bb"
    sha256 cellar: :any,                 arm64_ventura:  "c1149308b89c1007bf94b5ad6422a4c6e3af115ce5506de6125622eca7d19131"
    sha256 cellar: :any,                 arm64_monterey: "1607526d4c4c5a036b59014ac955c8f0134fa0720d06b147f816daa75f5f37f0"
    sha256 cellar: :any,                 sonoma:         "006c37831955bb0cfaac98d166024a970460671b1c6735fb85bbc5680bf82119"
    sha256 cellar: :any,                 ventura:        "389047d9e354d4022efb95b2edb9656a8b8afb86cdc2f5d64d90c9e47470e1f3"
    sha256 cellar: :any,                 monterey:       "d6ea43e28a909f2a077ee8d643e55e99bfe07f700540a0472b90e433215fc0a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a015b352085e86fab72162cf4429a57632ea862d041ac397c552bea38faccd4"
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

class Stormlib < Formula
  desc "Library for handling Blizzard MPQ archives"
  homepage "http://www.zezula.net/en/mpq/stormlib.html"
  url "https://github.com/ladislav-zezula/StormLib/archive/refs/tags/v9.40.tar.gz"
  sha256 "f80b08bae168888702a4251312d6c2279f487673df611c2b5ef4f395e810c3b1"
  license "MIT"
  head "https://github.com/ladislav-zezula/StormLib.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "eb01da3bc4fd5f900375f2543ee39f03fb878f109eff9f54606faaa668cfc722"
    sha256 cellar: :any, arm64_sequoia: "fac15e52ced12af3236c07b4247f0c687fa40c6fa7ff41c94823f16c7f20e6ad"
    sha256 cellar: :any, arm64_sonoma:  "303f4afbd38d37580129a9666aca2fc23e775deb9eaa10308be2f6d250af4b80"
    sha256 cellar: :any, sonoma:        "c6a04b2548b29f7d188301169d653bbdbaa45df2bfbaa8636df60c73b57ce516"
    sha256 cellar: :any, arm64_linux:   "6039a46e3b103c3356ccbc94f62204e170d9808502d956063edd3ad7fb609fba"
    sha256 cellar: :any, x86_64_linux:  "5917da8f3728c4eb24b7da68e0f1e07ee9b70677965f1f92bc1a5aff0179f30c"
  end

  depends_on "cmake" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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

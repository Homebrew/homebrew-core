class Stormlib < Formula
  desc "Library for handling Blizzard MPQ archives"
  homepage "http://www.zezula.net/en/mpq/stormlib.html"
  url "https://github.com/ladislav-zezula/StormLib/archive/v9.24.tar.gz"
  sha256 "33e43788f53a9f36ff107a501caaa744fd239f38bb5c6d6af2c845b87c8a2ee1"
  license "MIT"
  head "https://github.com/ladislav-zezula/StormLib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "634532f2ce69034249154aa8064c267903f37cde59b020de400edbc6b1a015f9"
    sha256 cellar: :any,                 arm64_monterey: "eb49ee0d868f90645193babd489badae79d5d00ca7ede13013f1e59060bbc770"
    sha256 cellar: :any,                 arm64_big_sur:  "339ba3a797c4e4e778605cf162ac730bec7800efb83559a9d8c2869334ffe6ef"
    sha256 cellar: :any,                 ventura:        "751559e18674e8b1b8a3b27bbe2f6ab309bf719a0f07697d2e30b8bb9859d974"
    sha256 cellar: :any,                 monterey:       "f259e5472e2b4dc860b0d56070b9ef65a9c5da60af9f456470e47632a9e1e156"
    sha256 cellar: :any,                 big_sur:        "bc0569b5bf83746075a6c732e88ea256297b99f2b1e87763eafc2f988c5b953a"
    sha256 cellar: :any,                 catalina:       "d40db23bd0e88f802e8971544de7ac57599a150df3debf2fb2032104a0599d30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fbc2be72468c6fdef29cc7130f26bd3d7c606e58b02ee41a3d952a2a754c51c"
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

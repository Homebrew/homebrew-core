class Stormlib < Formula
  desc "Library for handling Blizzard MPQ archives"
  homepage "http://www.zezula.net/en/mpq/stormlib.html"
  url "https://github.com/ladislav-zezula/StormLib/archive/refs/tags/v9.31.tar.gz"
  sha256 "c8d77e626cc907c8f2d00bb5c48f9d6c70344848d49cab4468f6234afaf815c1"
  license "MIT"
  head "https://github.com/ladislav-zezula/StormLib.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "96e129fd5dd134918fc64ce2a706deb1e7911e7a6ea98bc709e207b797388d75"
    sha256 cellar: :any,                 arm64_sequoia: "f2e00691eec59dc82510bc91264312663640b906b2f484f209e3d33efb4a813a"
    sha256 cellar: :any,                 arm64_sonoma:  "4ffca97a33b072d0823035dc6a757c7fbf96041ee7bbf6581dfa6639481bb60d"
    sha256 cellar: :any,                 sonoma:        "a2e153410331b03506c454ac4240ba49acd06da4e5149cf759f20a6a465d07ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77271d55a05e72595f18e3a611b7994b607e6c8fdb7e181a143f80298228d792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c22bb47d47efd4d54345ab1c348f4e9d9ab81149a3e59b129fd2e5703d3ace05"
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

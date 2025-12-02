class Supertux < Formula
  desc "Classic 2D jump'n run sidescroller game"
  homepage "https://www.supertux.org/"
  license "GPL-3.0-or-later"
  revision 12

  stable do
    url "https://github.com/SuperTux/supertux/releases/download/v0.6.3/SuperTux-v0.6.3-Source.tar.gz"
    sha256 "f7940e6009c40226eb34ebab8ffb0e3a894892d891a07b35d0e5762dd41c79f6"

    depends_on "boost"

    # Workaround to build with Boost 1.89.0 until new release that drops Boost dependency
    # https://github.com/SuperTux/supertux/commit/5333cebf629eb20621b284fc96b494257f3314bb
    patch :DATA
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b3aa57f4eee7ae7c84e67e89229a9daeaeede9e93886e1611c98e9bdc5ac935d"
    sha256 cellar: :any,                 arm64_sequoia: "9babc91234fa8859afc033a96ef11d755f4b889b7d70ca36c5e915d905b2bb97"
    sha256 cellar: :any,                 arm64_sonoma:  "c79a88e221ba8b3c4adedcb9d4b1e2122049794c86b4c7810d416c768b1722ee"
    sha256 cellar: :any,                 arm64_ventura: "ef691781ca584343e444017931593b6088600bb907f573410273be0fcc0ae897"
    sha256 cellar: :any,                 sonoma:        "3329f1bbbe360dc57de237ad59332fca8b9ed90fb3f58ea92b56d605b6a928f7"
    sha256 cellar: :any,                 ventura:       "90f03927a7a7060b24dade4c6e78f5e44851338637d605e7f2eb57218c02ea6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb8c3e3818fde3d9770c19b648959aaba3883ce22bc7178a863db8e7de43da51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23828dd1619319db46d09505c8a368100f4614ff397c666e45b74b623498375d"
  end

  head do
    url "https://github.com/SuperTux/supertux.git", branch: "master"

    depends_on "fmt"
    depends_on "openal-soft"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "glew"
  depends_on "glm"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "physfs"
  depends_on "sdl2"
  depends_on "sdl2_image"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
    depends_on "openal-soft"
  end

  def install
    # Support cmake 4 build, upstream pr ref, https://github.com/SuperTux/supertux/pull/3290
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

    args = [
      "-DINSTALL_SUBDIR_BIN=bin",
      "-DINSTALL_SUBDIR_SHARE=share/supertux",
      # Without the following option, Cmake intend to use the library of MONO framework.
      "-DPNG_PNG_INCLUDE_DIR=#{Formula["libpng"].opt_include}",
    ]
    args << "-DCMAKE_INSTALL_RPATH=#{rpath}" if build.head?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Remove unnecessary files
    rm_r(share/"applications")
    rm_r(share/"pixmaps")
    rm_r(prefix/"MacOS") if OS.mac?
  end

  test do
    (testpath/"config").write "(supertux-config)"
    assert_equal "supertux2 v#{version}", shell_output("#{bin}/supertux2 --userdir #{testpath} --version").chomp
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index b77029c0a..1842b4943 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -171,7 +171,7 @@ if(ENABLE_BOOST_STATIC_LIBS)
 else(ENABLE_BOOST_STATIC_LIBS)
   set(Boost_USE_STATIC_LIBS FALSE)
 endif(ENABLE_BOOST_STATIC_LIBS)
-find_package(Boost REQUIRED COMPONENTS filesystem system date_time locale)
+find_package(Boost REQUIRED COMPONENTS filesystem date_time locale)
 include_directories(SYSTEM ${Boost_INCLUDE_DIR})
 link_directories(${Boost_LIBRARY_DIRS})
 

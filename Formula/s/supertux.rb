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
    sha256 cellar: :any,                 arm64_sequoia: "3f63bbb4a3eca63586e1bcb23482fdcdd91936e6b6bd181ca5b6d3f4b57c463e"
    sha256 cellar: :any,                 arm64_sonoma:  "f44ec03e212e95daaa1cc85363c084e5dc545ac9be24812aa64f6d3a43046791"
    sha256 cellar: :any,                 arm64_ventura: "06b04d4dd7d3d6b93267084773b6eef6bddf762a7ff8b6c648ed8d356341f959"
    sha256 cellar: :any,                 sonoma:        "557c18f4f4c2dd4d3b1c987059690602188eda7e1418b7b8c01ccae52386d6d6"
    sha256 cellar: :any,                 ventura:       "e73a70f1403a6bd2f577c98e400ede1038132bc060b2dbdb748bee766db53967"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f8daa7588e6d322264e298f32571ef9bce8fe2eb3c967440956cbed60c14668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22bdb84ff6294cb2c5bf52ca70ee7b98b5c463b33be62b8e5ef373f859df5729"
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
 

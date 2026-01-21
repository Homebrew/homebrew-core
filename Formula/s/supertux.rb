class Supertux < Formula
  desc "Classic 2D jump'n run sidescroller game"
  homepage "https://www.supertux.org/"
  license "GPL-3.0-or-later"
  revision 14

  stable do
    url "https://github.com/SuperTux/supertux/releases/download/v0.6.3/SuperTux-v0.6.3-Source.tar.gz"
    sha256 "f7940e6009c40226eb34ebab8ffb0e3a894892d891a07b35d0e5762dd41c79f6"

    depends_on "boost"

    # Backport fix for newer GCC
    patch do
      url "https://github.com/SuperTux/supertux/commit/81809dd5e6f611b1d64d952f6d96310bcc9c5fca.patch?full_index=1"
      sha256 "cd251ef6831c482c32e5aa2c56422cad2898747493797b4018f02131ea19dc88"
    end

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
    sha256 cellar: :any,                 arm64_tahoe:   "1c4701340b11843553f6922c167116e304e72d2434ee160e9ec896204951588e"
    sha256 cellar: :any,                 arm64_sequoia: "0a12ac4b7ef4b2f7799067faeb3f6c3e4647750352475bf5ebc3be74222d04c5"
    sha256 cellar: :any,                 arm64_sonoma:  "ec45a9f9e6f37817f2ba510d879e79b15983fad78faad793ae16334b726243ed"
    sha256 cellar: :any,                 sonoma:        "c671a25824640dfe14b1a933e892ae05fde85fa3489aba663fe531726148eba8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee5760b28a84c5527e010fe27b90b79de271f5543c8658313145be9973d6c7f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3160e4e4d8ffd6fa679a9e79ca127e01e783d9863dba4ca6a8c2785bb6764209"
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
 

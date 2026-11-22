class Supertux < Formula
  desc "Classic 2D jump'n run sidescroller game"
  homepage "https://www.supertux.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://github.com/SuperTux/supertux/releases/download/v0.7.0.1/SuperTux-v0.7.0.1-Source.tar.gz"
    sha256 "c3a3813bc57b8267960e4fcc33afe5f5cb468abe2a288fe58da4f288d0d7442c"

    depends_on "sdl2-compat"
    depends_on "sdl2_image"
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "5612d250d91e16c26ce7d8841058d5cd26ee35a6af15e0731598c95a556b36c4"
    sha256 cellar: :any, arm64_golden_gate: "adbd10311e415e487c45af03cf2603d4b514c0ba534d225d4575ae040e18cfe4"
    sha256 cellar: :any, arm64_tahoe:       "5104dbb3c15805361140cb21c2b7711b820673b86ae5a99dac6082673174dc46"
    sha256 cellar: :any, arm64_sequoia:     "d0d9a86edcc56293a2d7e8e4b836880ffbd9137efbf3aff8851a562fd725a4b0"
    sha256 cellar: :any, arm64_linux:       "efd4ae6d6d671e8c91e484f8f9f56defe15d63bf3df334d8b7092861af30b14d"
    sha256 cellar: :any, x86_64_linux:      "d29d4802cf0dd5541afdcc05e8b91d485b437d23e05d1ca01748c4b693460ad4"
  end

  head do
    url "https://github.com/SuperTux/supertux.git", branch: "master"

    depends_on "sdl3"
    depends_on "sdl3_image"
    depends_on "sdl3_ttf"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "fmt"
  depends_on "freetype"
  depends_on "glew"
  depends_on "glm"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "openal-soft"
  depends_on "physfs"

  uses_from_macos "curl"

  on_linux do
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  def install
    args = [
      "-DINSTALL_SUBDIR_BIN=bin",
      "-DINSTALL_SUBDIR_SHARE=share/supertux",
      # Without the following option, Cmake intend to use the library of MONO framework.
      "-DPNG_PNG_INCLUDE_DIR=#{formula_opt_include("libpng")}",
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
      # Avoid bundling dependency dylibs into `MacOS/` and overriding the rpath
      "-DDISABLE_CPACK_BUNDLING=ON",
      "-DINSTALL_SUBDIR_DOC=share/doc/supertux2",
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Remove unnecessary app bundle skeleton
    rm_r(prefix/"SuperTux.app") if OS.mac?
  end

  test do
    (testpath/"config").write "(supertux-config)"
    assert_equal "supertux2 v#{version}", shell_output("#{bin}/supertux2 --userdir #{testpath} --version").chomp
  end
end

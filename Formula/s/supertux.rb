class Supertux < Formula
  desc "Classic 2D jump'n run sidescroller game"
  homepage "https://www.supertux.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://github.com/SuperTux/supertux/releases/download/v0.7.0.2/SuperTux-v0.7.0.2-Source.tar.gz"
    sha256 "e37845e1c3efa5a095f2a1f5efd59f1d447e31ea3db37fc6dcb963ca438fbc87"

    depends_on "sdl2-compat"
    depends_on "sdl2_image"
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "62c8ad4ac0a385b9f6617d197f4e41a9749da7d4378df2fc05c3e7cfdbf6d6e7"
    sha256 cellar: :any, arm64_golden_gate: "fce254f371c6b9ce1dad7378f0a91c9b26aab8ee150626f065ecc5d2942abdc2"
    sha256 cellar: :any, arm64_tahoe:       "70b08c765afcc66b84d3da111697178a202645eea2f4d27dffa91b072bb5ea59"
    sha256 cellar: :any, arm64_sequoia:     "99503fbe1910d31d524582719397d87941115ad04ec081231f383ca3ca78939d"
    sha256 cellar: :any, arm64_linux:       "a3d0465cae53d66c455783df565c0901b5ac8f5f05abac9c6be2f9d16529e062"
    sha256 cellar: :any, x86_64_linux:      "ad38fa7dd29c1683c568f25a97ab0e6e24091c28bc9443cb087267989b2adabe"
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

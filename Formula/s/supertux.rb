class Supertux < Formula
  desc "Classic 2D jump'n run sidescroller game"
  homepage "https://www.supertux.org/"
  url "https://github.com/SuperTux/supertux/releases/download/v0.7.0/SuperTux-v0.7.0-Source.tar.gz"
  sha256 "32fc5b99b9994ed58e58341d6f21de925764b381256e108591136de53bc31da5"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "90e8bb806543bea14b1ff9a90c12b18d1366a92b172f5d48186f245ef82729be"
    sha256 cellar: :any,                 arm64_sequoia: "11bb1bad9aafae4445904c65eb9b4e18812bcedc1714699bc1f79f234e0209ef"
    sha256 cellar: :any,                 arm64_sonoma:  "caa57067cd1dfa66e3d39669e7d89ca92c158b54f9b1fc85b88acd626ba2587d"
    sha256 cellar: :any,                 sonoma:        "25124eaad411fdc607c923d4a79afe0b5e29e19a3a58b61ef58481b6844d0ffb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd46b29b85232c359dd1d6cb4964190d01a3be01d51579b58299313a699e8c1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c8498d5a9d604d055d87358da12507286ba6954153b1f202f5c552b3e89ecde"
  end

  head do
    url "https://github.com/SuperTux/supertux.git", branch: "master"

    depends_on "fmt"
    depends_on "openal-soft"
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
  depends_on "sdl2"
  depends_on "sdl2_image"

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
      "-DPNG_PNG_INCLUDE_DIR=#{Formula["libpng"].opt_include}",
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
    ]

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

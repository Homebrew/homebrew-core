class Supertux < Formula
  desc "Classic 2D jump'n run sidescroller game"
  homepage "https://www.supertux.org/"
  url "https://github.com/SuperTux/supertux/releases/download/v0.6.3/SuperTux-v0.6.3-Source.tar.gz"
  sha256 "f7940e6009c40226eb34ebab8ffb0e3a894892d891a07b35d0e5762dd41c79f6"
  license "GPL-3.0-or-later"
  revision 5
  head "https://github.com/SuperTux/supertux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "10c0c7d82c4febfe1f5b5bbc6b0211c2059dd88f06deec4a49ba66714db4178a"
    sha256 cellar: :any,                 arm64_monterey: "e5c784e30f00052d68f402ac8de525ce4c7af69099eee823d04ee3efc4e52cd5"
    sha256 cellar: :any,                 arm64_big_sur:  "32425f5048b29966d32a6c864b69bde8fff548e490c4a21ce5c26506885abb1f"
    sha256 cellar: :any,                 ventura:        "99daaa4aa45da2c7e8df9ab09522294bbc2791529b86d61ff587225a3ff62cc3"
    sha256 cellar: :any,                 monterey:       "ab0f2f0bc71f37dbd6743f5a7de71649ddd013ad34add68a4ad9b256466e374e"
    sha256 cellar: :any,                 big_sur:        "8544df6656d9e2cc0414c4cf9ba14e5e459e84ab01ea828a00dd41c77c55e9cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c9a51832d4daac56cff59ead774f542a2c25de35a7a7294b80e3c357c159921"
  end

  depends_on "cmake" => :build
  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "physfs"
  depends_on "sdl2"
  depends_on "sdl2_image"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openal-soft"
  end

  def install
    ENV.cxx11

    args = std_cmake_args
    args << "-DINSTALL_SUBDIR_BIN=bin"
    args << "-DINSTALL_SUBDIR_SHARE=share/supertux"
    # Without the following option, Cmake intend to use the library of MONO framework.
    args << "-DPNG_PNG_INCLUDE_DIR=#{Formula["libpng"].opt_include}"
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Remove unnecessary files
    (share/"applications").rmtree
    (share/"pixmaps").rmtree
    (prefix/"MacOS").rmtree if OS.mac?
  end

  test do
    (testpath/"config").write "(supertux-config)"
    assert_equal "supertux2 v#{version}", shell_output("#{bin}/supertux2 --userdir #{testpath} --version").chomp
  end
end

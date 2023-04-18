class Supertux < Formula
  desc "Classic 2D jump'n run sidescroller game"
  homepage "https://www.supertux.org/"
  url "https://github.com/SuperTux/supertux/releases/download/v0.6.3/SuperTux-v0.6.3-Source.tar.gz"
  sha256 "f7940e6009c40226eb34ebab8ffb0e3a894892d891a07b35d0e5762dd41c79f6"
  license "GPL-3.0-or-later"
  revision 4
  head "https://github.com/SuperTux/supertux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d35e3d1d9acf5f26cefb4c089f3d509350c6884f59376f087d05cb99118fbf2c"
    sha256 cellar: :any,                 arm64_monterey: "6f65c4732bb3f808e4a0812942e3a867854f4497cfa571f041cd6ec781fe16e0"
    sha256 cellar: :any,                 arm64_big_sur:  "c7b14370edd788d14e52ec8dbb612de78f51ae48f9127a453a4cae27a6c81785"
    sha256 cellar: :any,                 ventura:        "f4f9be28f737619879675198532cf0eae31bc06b441789faf4089aa731786b99"
    sha256 cellar: :any,                 monterey:       "b0ab1302d8de0bf3a90e8e29c5f16ab470d0dd07066f0cfda36fc7e8d467781c"
    sha256 cellar: :any,                 big_sur:        "df90443cb1320609aae4b62a1f3e525ffb9e27faae3d7fa1e5d1108a893cf48d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b79f3e71041f84e843777e9e916f36df6d93e08ba61cca3974e9732456251260"
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

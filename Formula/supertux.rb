class Supertux < Formula
  desc "Classic 2D jump'n run sidescroller game"
  homepage "https://www.supertux.org/"
  url "https://github.com/SuperTux/supertux/releases/download/v0.6.3/SuperTux-v0.6.3-Source.tar.gz"
  sha256 "f7940e6009c40226eb34ebab8ffb0e3a894892d891a07b35d0e5762dd41c79f6"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/SuperTux/supertux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "607f360e5deb898cd921a3f323b4ddeda761a7325c3d6b0a8071070e49ede921"
    sha256 cellar: :any,                 arm64_big_sur:  "09834f09cc4225d02baa38696a9ae61f57639568a1c9d1f59a9dfc66defb6c44"
    sha256 cellar: :any,                 monterey:       "57355641e3804d18e7182ea65a9aacae427df55490a8503908f0c1764234a9ab"
    sha256 cellar: :any,                 big_sur:        "5cb56704aa21770a81b84cd081ecd29039c73d17fffe5ba7cac897dff4b26a5e"
    sha256 cellar: :any,                 catalina:       "4adb84bd37e6dcf789d2064c5e1bc2df7398c33946ac11b6868180b468328ddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44bcb214ae0d1d29aece28905aac5c9a8c6c905d46dabcd6bdc5a8cc1679ea08"
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

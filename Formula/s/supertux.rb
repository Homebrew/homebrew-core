class Supertux < Formula
  desc "Classic 2D jump'n run sidescroller game"
  homepage "https://www.supertux.org/"
  url "https://github.com/SuperTux/supertux/releases/download/v0.6.3/SuperTux-v0.6.3-Source.tar.gz"
  sha256 "f7940e6009c40226eb34ebab8ffb0e3a894892d891a07b35d0e5762dd41c79f6"
  license "GPL-3.0-or-later"
  revision 10
  head "https://github.com/SuperTux/supertux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "326f5e0abf6bbd1b2f63ab48333a5632fde9ae8ac8f0e1fee07004e90d3a8b42"
    sha256 cellar: :any,                 arm64_sonoma:  "bf73163209acf00fe8743f565a6398366872c61046f23766d3d83c5751f81597"
    sha256 cellar: :any,                 arm64_ventura: "3ef80f4789f23dc9565ebe7175f50020e0709098abffd5368c9306a8e44312ab"
    sha256 cellar: :any,                 sonoma:        "a0d8f4dd446e4caf9462f3363f472c5ae3232c1c8df465451233eba84df4eed3"
    sha256 cellar: :any,                 ventura:       "7696d453e5273c69ca2f1703edee2edd461b0f06393900eea403614c5dee5403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ff216442006b1a0e4244d1a126d339a36b524eac1c88f35079ec0c58b6b77fa"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
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
    ENV.cxx11

    args = [
      "-DINSTALL_SUBDIR_BIN=bin",
      "-DINSTALL_SUBDIR_SHARE=share/supertux",
      # Without the following option, Cmake intend to use the library of MONO framework.
      "-DPNG_PNG_INCLUDE_DIR=#{Formula["libpng"].opt_include}",
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

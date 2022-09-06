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
    sha256 cellar: :any,                 arm64_monterey: "553314454bc8d7afc071a8b1586af1d742b7419974cf66172e218c36ad92aaa9"
    sha256 cellar: :any,                 arm64_big_sur:  "6bb26ea7c882610fb2cd8b6b2dda9da5d4c359282b89b0141ad050c5d40e0c76"
    sha256 cellar: :any,                 monterey:       "d739fb255f129b5ed5a561269549f9d56cee5b84c290af9b5401abca8fef5717"
    sha256 cellar: :any,                 big_sur:        "70f15e4b05a5d5cf3df8fb746320674bf5bdecef13c5cf14b2adf28f55516227"
    sha256 cellar: :any,                 catalina:       "8d4d6929a0b143b7cc2e2136d3399e9ad98c5a69221cffd600d1f9c4adda7050"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69a2c50dd69030007a0e10f59702009a47298a69dbb683e9c9392197b111ade6"
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

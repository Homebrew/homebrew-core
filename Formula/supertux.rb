class Supertux < Formula
  desc "Classic 2D jump'n run sidescroller game"
  homepage "https://www.supertux.org/"
  url "https://github.com/SuperTux/supertux/releases/download/v0.6.3/SuperTux-v0.6.3-Source.tar.gz"
  sha256 "f7940e6009c40226eb34ebab8ffb0e3a894892d891a07b35d0e5762dd41c79f6"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/SuperTux/supertux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f9677deb13c19bdd3e76c135e2fb2d961ddbf6f98d4e305fc1605e3c4a2bf103"
    sha256 cellar: :any,                 arm64_big_sur:  "9a68b3e319f61d99118584fd5a007291db8d5c8d076c5a643b541b33eda928cf"
    sha256 cellar: :any,                 monterey:       "63ef627b954b70207338d052603dbcc6135421549dcecd01324d10a8e9e6165e"
    sha256 cellar: :any,                 big_sur:        "a767e80bf9819fa11cafdd3083f9e263cf10049410a3133efbcb8b112854ce35"
    sha256 cellar: :any,                 catalina:       "1807232df5b7acccfe300a8e79353c076a9031f3056e24bf653492cf2df37472"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "201ebccb650519184532f54602b2e51911dfa079e60152bfadca5ea07b901f1c"
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

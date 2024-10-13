class Supertux < Formula
  desc "Classic 2D jump'n run sidescroller game"
  homepage "https://www.supertux.org/"
  url "https://github.com/SuperTux/supertux/releases/download/v0.6.3/SuperTux-v0.6.3-Source.tar.gz"
  sha256 "f7940e6009c40226eb34ebab8ffb0e3a894892d891a07b35d0e5762dd41c79f6"
  license "GPL-3.0-or-later"
  revision 9
  head "https://github.com/SuperTux/supertux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "01535f3ec74e4f3e9956da66f52bb6d0e37696171d6d0169e498311589f2f1b6"
    sha256 cellar: :any,                 arm64_sonoma:   "0e94fb77138b727f154c9dbb8ad6bafa6b0f5d0558f99b4ab0381b5241c9300c"
    sha256 cellar: :any,                 arm64_ventura:  "5dde9e8355c08783ce8e120e29386139dcb625dac4eea60c293f74d94a0c9c0d"
    sha256 cellar: :any,                 arm64_monterey: "3ee3e444f0ae273969dcffb6d4b2854cbcad4d3a13ecbe5485ed493c2df9b718"
    sha256 cellar: :any,                 sonoma:         "e8b8f690bda931e2a87a285c296cc6e445ec689ae7f9c6c154949642ba12b37a"
    sha256 cellar: :any,                 ventura:        "e6105c9ff04aedf7a60b21b42e5ec772aa8a3702422123eea5edd8887823d785"
    sha256 cellar: :any,                 monterey:       "6c022c0e53b1cb0454412dd1f2e9a5d34cf08c23f4967ce3e6ac16533d981f7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91a815ea74c91611c4ba47b4201bc38b42e13d1ee4e7039724dd2c7a75d9224c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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

    args = std_cmake_args
    args << "-DINSTALL_SUBDIR_BIN=bin"
    args << "-DINSTALL_SUBDIR_SHARE=share/supertux"
    # Without the following option, Cmake intend to use the library of MONO framework.
    args << "-DPNG_PNG_INCLUDE_DIR=#{Formula["libpng"].opt_include}"
    system "cmake", "-S", ".", "-B", "build", *args
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

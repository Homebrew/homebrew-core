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
    sha256 cellar: :any,                 arm64_monterey: "052322840a5515495b30ca53f026ad78731ed3e0449cbfed92a926ccc27c5199"
    sha256 cellar: :any,                 arm64_big_sur:  "b5f2b0dbf95c98f59d7c939f7350c03aaf15482c5bca9a58afdab0d7ea8e3b41"
    sha256 cellar: :any,                 monterey:       "df5093e4b9825cc6e270c64c57577879d8d6aa89e4803ea8f7ecd061290ee27f"
    sha256 cellar: :any,                 big_sur:        "79a3ed56412120db54a25502c915d8375cee5c13866dc6c2fba6fd861d423268"
    sha256 cellar: :any,                 catalina:       "10aba5baa7d1dd9e8831f360ec9818f26bae2ba89ee8a3474b00115b4a92121b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddc402083ffea0ee2c54fb1e5eb59f86103b367b3b6de5420fa3bf3c00abd3cc"
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

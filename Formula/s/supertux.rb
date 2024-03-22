class Supertux < Formula
  desc "Classic 2D jump'n run sidescroller game"
  homepage "https://www.supertux.org/"
  url "https://github.com/SuperTux/supertux/releases/download/v0.6.3/SuperTux-v0.6.3-Source.tar.gz"
  sha256 "f7940e6009c40226eb34ebab8ffb0e3a894892d891a07b35d0e5762dd41c79f6"
  license "GPL-3.0-or-later"
  revision 7
  head "https://github.com/SuperTux/supertux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7e2b853ed68b186f45557f0c8677113bca6fc344d4736ca8b45900be26225bb2"
    sha256 cellar: :any,                 arm64_ventura:  "554897532932b287e792f8334a971e48bfe73665544e204149887c6babe18640"
    sha256 cellar: :any,                 arm64_monterey: "57279daa505e8de2cb2459705a0f832d4d8e95eda301af458b1e2808847c0ddd"
    sha256 cellar: :any,                 sonoma:         "0b753605171b7078f09acec96f7be428bf925134818e4a9425e58e6d33c8c311"
    sha256 cellar: :any,                 ventura:        "84579f1ef67ed47e61104c8bc231e8b479b8a3f5c58fb27ab22f219a70142ba9"
    sha256 cellar: :any,                 monterey:       "dc5f5d5ded62bd3766b5797989d275d98aa39d745f3617665f7f9fe52c428339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4897be6e43435e85749297493d7cbd52e55771d51150ea4a72aeae40aa04e437"
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

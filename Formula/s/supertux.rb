class Supertux < Formula
  desc "Classic 2D jump'n run sidescroller game"
  homepage "https://www.supertux.org/"
  url "https://github.com/SuperTux/supertux/releases/download/v0.6.3/SuperTux-v0.6.3-Source.tar.gz"
  sha256 "f7940e6009c40226eb34ebab8ffb0e3a894892d891a07b35d0e5762dd41c79f6"
  license "GPL-3.0-or-later"
  revision 8
  head "https://github.com/SuperTux/supertux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "643998d036a5cb35fdd2b73bb22502ca2760261718a166722a73a2c2aba32d6c"
    sha256 cellar: :any,                 arm64_ventura:  "30a29f905c961ace430d45d7c01dc11dc129d2aaf2d078c62bd2cf23ae500fab"
    sha256 cellar: :any,                 arm64_monterey: "92121f94686a32a3fbf9a12ce3bc0a29b8f4af7dcd6885f088464d2b91bf3f30"
    sha256 cellar: :any,                 sonoma:         "673eb3f2e6977afe5b21702c762ea85762aa44b13688d4f79ad2e070848fb979"
    sha256 cellar: :any,                 ventura:        "0613b65b47e9447934a6c8f876a2dd626dcc8f4c915df6c7963ac45b25487a3b"
    sha256 cellar: :any,                 monterey:       "a2560c895f0aaf27cdf75c0b66c802e2658a0d481ac63ee72ef7915bc48ac5f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7f4e08dd983b9849ea38e0d35de2641b4be25771ad307d747f079ed3630e111"
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

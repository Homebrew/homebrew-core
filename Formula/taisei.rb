class Taisei < Formula
  desc "Clone of Touhou Project shoot-em-up games"
  homepage "https://taisei-project.org/"
  url "https://github.com/taisei-project/taisei.git",
      :tag => "v1.1.2",
      :revision => "3c5da74722b445c6aaf8af7666ba2e7e29fb4ccb"

  bottle do
    cellar :any
    sha256 "c3acac540c33b8de9aa0ad12f0557c8093749ec1cd3e9733d383f54317d972df" => :high_sierra
    sha256 "cbbaa38a4d7f5cd27a67f691f054d373e0d24cffa18653b4fa7e7241225d9e45" => :sierra
    sha256 "c991ad863e68b3e115b758522e1535a6eb36c770fdd53cf968efd573e4b77512" => :el_capitan
  end

  depends_on "bash" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libzip"
  depends_on :python3
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  def install
    mkdir "build" do
      system "cmake", "..", "-DOSX_TOOL_PREFIX=", "-DOSX_LIB_PATH=:",
             *std_cmake_args
      system "make", "install"
    end
  end

  def caveats
    "Sound may not work."
  end

  test do
    output = shell_output("#{prefix}/Taisei.app/Contents/MacOS/Taisei -h", 1)
    assert_match "Touhou clone", output
  end
end

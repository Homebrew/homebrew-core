class Taisei < Formula
  desc "Clone of Touhou Project shoot-em-up games"
  homepage "https://taisei-project.org/"
  url "https://github.com/taisei-project/taisei.git",
      :tag => "v1.1.2",
      :revision => "3c5da74722b445c6aaf8af7666ba2e7e29fb4ccb"
  revision 2

  bottle do
    cellar :any
    sha256 "3303678cfaa0f5e19f30649cb26042e22029946f7c7d36af58f5e617e41fe28e" => :high_sierra
    sha256 "c8148a8ee90632221ad5790f286d73af43d378e7fdc521a568b5bfb6732844f6" => :sierra
    sha256 "fed47ca7b0254468f374b1319347877a8c1cdb39253985de0151003d97d65e41" => :el_capitan
  end

  depends_on "bash" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libzip"
  depends_on "python3"
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

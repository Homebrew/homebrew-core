class Taisei < Formula
  desc "Clone of Touhou Project shoot-em-up games"
  homepage "https://taisei-project.org/"
  url "https://github.com/taisei-project/taisei.git",
      :tag => "v1.1.2",
      :revision => "3c5da74722b445c6aaf8af7666ba2e7e29fb4ccb"
  revision 2

  bottle do
    cellar :any
    sha256 "106e1f2849651dd5a320d23f7ee37ef1dbbfe64cbd04a5a052113156a21265e5" => :high_sierra
    sha256 "2af61820670dc5805d92d44d9306fc466a54bd9107e13c7980ff38fd4147d75e" => :sierra
    sha256 "469f2a84ac00b5f0d7c6b49eaae35dd6074f81abadb7c0d6146ce3602e21e4af" => :el_capitan
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

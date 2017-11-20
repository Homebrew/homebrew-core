class Taisei < Formula
  desc "Clone of Touhou Project shoot-em-up games"
  homepage "https://taisei-project.org/"
  url "https://github.com/taisei-project/taisei.git",
      :tag => "v1.1.2",
      :revision => "3c5da74722b445c6aaf8af7666ba2e7e29fb4ccb"

  bottle do
    cellar :any
    sha256 "a5a8eb570695059eecce523e1045e75e2a6800cb75b242d7580003efbe5f01aa" => :high_sierra
    sha256 "b582f24f31ff439cdedecc03ef47ef8a40b052dec8c34e094e9bb91cfe702574" => :sierra
    sha256 "c4fa3224169c02361a25a77b404a5b0cbedeb55b901fde19a1467c061a26c629" => :el_capitan
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

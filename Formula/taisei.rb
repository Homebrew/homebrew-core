class Taisei < Formula
  desc "Clone of Touhou Project shoot-em-up games"
  homepage "http://taisei-project.org/"
  url "https://github.com/laochailan/taisei/archive/v1.0a.tar.gz"
  version "1.0a"
  sha256 "1561c84c9fd8b9c7a91b864bdfc07fb811bb6da5c54cf32a2b6bd63de5f8f3ff"

  bottle do
    sha256 "65645d9889942f99b5bbc3f13f5786a1d97b4ff4b0439702c576016a8516768e" => :el_capitan
    sha256 "bc5d235333d79b94471a6a9983bfb44513f50ee460bceb3d0d3a202bbfaa39f3" => :yosemite
    sha256 "d8214d4d25532caa5c69f09f754a9faccbe55f7408fa1e9e9c3cd8c75f23b48b" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "freealut"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "openal-soft" # OpenAL.framework gave ALUT state error
  depends_on "sdl"
  depends_on "sdl_ttf"

  # Fix newline at end of file to match master
  patch do
    url "https://github.com/laochailan/taisei/commit/779ff58684b1f229aedfcc03bfc6ac7aac17bf6a.diff"
    sha256 "eec218752bb025024112442ed9a254e352f71be966de98c3d9d4f1ed482059a0"
  end

  # Fix missing inline symbols
  patch do
    url "https://github.com/laochailan/taisei/commit/0f78b1a7eb05aa741541ca56559d7a3f381b57e2.diff"
    sha256 "a68859106a5426a4675b2072eb659fd4fb30c46a7c94f3af20a1a2e434685e1b"
  end

  # Support macOS build
  patch do
    url "https://github.com/laochailan/taisei/pull/38.patch"
    sha256 "f40a7d4a917d6843803d2ca7e9fc7f42c7fcb53fc8683b60ec0223fe8110843e"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    (share/"applications").rmtree
    (share/"icons").rmtree
  end

  def caveats
    "Sound may not work."
  end
end

class Taisei < Formula
  desc "Clone of Touhou Project shoot-em-up games"
  homepage "https://taisei-project.org/"
  url "https://github.com/laochailan/taisei/archive/v1.0a.tar.gz"
  version "1.0a"
  sha256 "1561c84c9fd8b9c7a91b864bdfc07fb811bb6da5c54cf32a2b6bd63de5f8f3ff"

  bottle do
    sha256 "e41fc7a5c28ca97217135e413af393e05d09b7a4a2131a0fb292f9873f6bb326" => :sierra
    sha256 "4382fbd49e142c1fd318169ee8c91f1fff390c516b2f5fc5c6d975b330f8f472" => :el_capitan
    sha256 "3d5fa72700737fa76e87e21e6176b32f88ef4f5d464a2a0b4fa4b98b8509251b" => :yosemite
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

  # Support Mac OS X build
  patch do
    url "https://github.com/laochailan/taisei/commit/be8be15.patch"
    sha256 "29225ba39ce1aa093897ad4276da35a972b320e3ad01ffa14ab7b32e3acb4626"
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

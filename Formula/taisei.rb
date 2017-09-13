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
    url "https://github.com/laochailan/taisei/commit/779ff58684b1f229aedfcc03bfc6ac7aac17bf6a.diff?full_index=1"
    sha256 "8c3a8d2fa9be35df5212b8ea5d54e7d97a0ad09ef7b78078d8a33803f6913373"
  end

  # Fix missing inline symbols
  patch do
    url "https://github.com/laochailan/taisei/commit/0f78b1a7eb05aa741541ca56559d7a3f381b57e2.diff?full_index=1"
    sha256 "d3ab0ae7b2dad63f4a33af699218e905df1193e43857ae44181c5fc015168f93"
  end

  # Support Mac OS X build
  patch do
    url "https://github.com/laochailan/taisei/commit/be8be15.patch?full_index=1"
    sha256 "1830a52cb39020c349f681c8af459f96561c72466e279ec0fd08d2f2f096c516"
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

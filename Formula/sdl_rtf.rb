class SdlRtf < Formula
  desc "Sample library to display Rich Text Format (RTF) documents"
  homepage "https://www.libsdl.org/projects/SDL_rtf/"
  url "https://www.libsdl.org/projects/SDL_rtf/release/SDL_rtf-0.1.0.tar.gz"
  sha256 "3dc0274b666e28010908ced24844ca7d279e07b66f673c990d530d4ea94b757e"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c9d79a0cf619950aa552e22404c7105c41083f106acf9bc48437f4d53c41a879"
    sha256 cellar: :any,                 arm64_big_sur:  "9d08d7ff2342e161defb1160668e96414902afd78756e4ab3824915385574546"
    sha256 cellar: :any,                 monterey:       "6952f9f9fee9d2f3397666f18519ed7b2fe0cdc4bd9c29194066af13df3349b1"
    sha256 cellar: :any,                 big_sur:        "d4e19ead242e52808d739cf34bd91be0b941771291437eba0c8931263fcbf9f6"
    sha256 cellar: :any,                 catalina:       "ee09de7e32f0992acce56ab546fb0201d7b3903a51243548b590378cccc7e6f5"
    sha256 cellar: :any,                 mojave:         "310bcc2756a0ba5dd9287af9159809c2519609830e07e4ef0773edfc51c8bda5"
    sha256 cellar: :any,                 high_sierra:    "319fe65012c94d20675b0b3dc3c9e4df59838ccca7496b81a425bded94e3c9fc"
    sha256 cellar: :any,                 sierra:         "c34abb198f384916d7b2a09a88c69cb84f29674031329bb7a1733e8a5ed39255"
    sha256 cellar: :any,                 el_capitan:     "6c7e9f7459ff062fbb48ee1a383a4fd4acc2c29f5ee9b57dea93710c94ccda11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97d2c766e23be9693f5263f8018faac71206cabb5f00d878d879534dfe68b8c3"
  end

  head do
    url "https://github.com/libsdl-org/SDL_rtf.git", branch: "SDL-1.2"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # SDL 1.2 is deprecated, unsupported, and not recommended for new projects.
  disable! date: "2022-07-31", because: :deprecated_upstream

  depends_on "sdl12-compat"

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--prefix=#{prefix}", "--disable-sdltest"
    system "make", "install"
  end
end

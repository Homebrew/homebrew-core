class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r2117",
      revision: "71e2361042531fe767fb98300cf8c1ee95e539a0"
  version "r2117"
  license "ISC"
  revision 1
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  livecheck do
    url :stable
    regex(/([^"' >]+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cc16494090e481166eebd827eba42172321e9d85987897aa2a2e14272215105e"
    sha256 cellar: :any, arm64_sequoia: "280620bd9a157326fe31cce0bf7575887147a7399a78dcc9950039181b40fa4b"
    sha256 cellar: :any, arm64_sonoma:  "276590e9e0fb52abccb2ba01d0224308a1b7eaaf06931026024d0fea6a75cec0"
    sha256 cellar: :any, sonoma:        "48bac949ab508a2070b580a1d273579a1e8ac0f679e40c672b1ee946a12aea8b"
    sha256 cellar: :any, arm64_linux:   "befa92702eb318b44fbcf4ed8052cbb6541676b45db9f60e47d3fc8a2152b400"
    sha256 cellar: :any, x86_64_linux:  "cc96639cbdb0e56a3eadf2ff9c6969d52537e961de9cfc9e620c3577ad33b101"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "ffmpeg"
  depends_on "libao"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "speex"

  on_macos do
    depends_on "libogg"
  end

  def install
    # TODO: Try adding `-DBUILD_SHARED_LIBS=ON` in a future release.
    # Currently failing with requires target "g719_decode" that is not in any export set
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_AUDACIOUS:BOOL=OFF",
                    "-DUSE_CELT=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    lib.install "build/src/libvgmstream.a" # remove when switching to shared libs
  end

  test do
    assert_match "decode", shell_output("#{bin}/vgmstream-cli 2>&1", 1)
  end
end

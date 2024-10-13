class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r1951",
      revision: "4b2dc01ccdcd3eeccb7b2ca0d7a32692dfdec947"
  version "r1951"
  license "ISC"
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  livecheck do
    url :stable
    regex(/([^"' >]+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "320febc8b8756f21ae417f9bfca4115d9dee1b280ba1e4d37c4d5a782899e2d0"
    sha256 cellar: :any,                 arm64_sonoma:   "473e523caa4f0e1d7ddc10db89bd0026f9c77aa79ea14ed2e5397b2d6498beca"
    sha256 cellar: :any,                 arm64_ventura:  "3a8b812aee5900288cb4ce80da9c5ccbf7dd048b5c5c6c38cf4eaa9cc17fe459"
    sha256 cellar: :any,                 arm64_monterey: "143bd9cd3cbd99ef6215b8d7405d16be28dc4ddd2350a065083ace69d5b6c3e5"
    sha256 cellar: :any,                 sonoma:         "cdd43e401e7b9d329e14018ad3e749dc5a2889cecebecd09523924ab4de9ae53"
    sha256 cellar: :any,                 ventura:        "f0b9eca5a0aade2f45b8c20dfb74be67d8e11818122bca2cf8b59eb434d4fb64"
    sha256 cellar: :any,                 monterey:       "97a73ec58ba7f6e75056fd424a4c88343b6ab476763676aee8147e8d2122fcf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ace993f67bbb22a913e59246a9e6c9877bacebb8516aa07ac433f1e1609309b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "ffmpeg"
  depends_on "jansson"
  depends_on "libao"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "speex"

  on_macos do
    depends_on "libogg"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    ENV["LIBRARY_PATH"] = HOMEBREW_PREFIX/"lib"
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_AUDACIOUS:BOOL=OFF",
                    "-DUSE_CELT=OFF",
                    *std_cmake_args,
                    "-DFETCHCONTENT_FULLY_DISCONNECTED=OFF" # FIXME: Find a way to build without this.
    system "cmake", "--build", "build"
    bin.install "build/cli/vgmstream-cli", "build/cli/vgmstream123"
    lib.install "build/src/libvgmstream.a"
  end

  test do
    assert_match "decode", shell_output("#{bin}/vgmstream-cli 2>&1", 1)
  end
end

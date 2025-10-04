class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r2055",
      revision: "f499bf0c8b8d746ab2bd7feebd914d972ef40fec"
  version "r2055"
  license "ISC"
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  livecheck do
    url :stable
    regex(/([^"' >]+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "95f555a4ebae967e06fa52f6d49591c155bbf9de76319810103be63f3b36509c"
    sha256 cellar: :any,                 arm64_sequoia: "ead8ddf1f27baefb7d612d6a8f6d4bd639fad43d26f07927b6ba7b7c3790d40c"
    sha256 cellar: :any,                 arm64_sonoma:  "190dcf8e315535c20f12236b232ba58fcd9384b89a6b06a496d3f4a39fc33fcd"
    sha256 cellar: :any,                 sonoma:        "e4c2649bfa4b4312947ef25e0c4a039cdbf012dd1ed27bd5ac40d56fa2e7b41c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27f007d2599de73dc38adda802b63e697045fa2d6b4c149b53953560219aecc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b41fedd96803ea083f2bbe486e2818da5fd985b96daaa2d294c36fd448471714"
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

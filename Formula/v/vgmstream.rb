class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r1980",
      revision: "ed9a720221b4b0f2589a3860ad72631cec7145e9"
  version "r1980"
  license "ISC"
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  livecheck do
    url :stable
    regex(/([^"' >]+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "75a6b8078174350d2b60e3e5f21483f99e6359f91623ab250a04bb96047155e6"
    sha256 cellar: :any,                 arm64_sonoma:  "1ec242a9fb138a7e75fae88605fd44ce2ffe572e7c43e74e6c0aec9c833d68d2"
    sha256 cellar: :any,                 arm64_ventura: "d5fe68c483cc091a6a8dccda1350b4d085696a97394797f6bbac34833d3824ee"
    sha256 cellar: :any,                 sonoma:        "8aa64f2d3917a9371236ae65b9e84caebebe78516df124c61c02432a5a04775e"
    sha256 cellar: :any,                 ventura:       "9aca5ff0cec94404742b05a712e0614780319229191146d2fce6289e029dbe2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b84d06605af52ad324986ef9ff63631ba6f2f56fc85984d695ef7e99348de66"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "ffmpeg"
  depends_on "jansson"
  depends_on "libao"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "speex"

  on_macos do
    depends_on "libogg"
  end

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

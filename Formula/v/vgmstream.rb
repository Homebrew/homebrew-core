class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r2023",
      revision: "f96812ead1560b43ef56d1d388a5f01ed92a8cc0"
  version "r2023"
  license "ISC"
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  livecheck do
    url :stable
    regex(/([^"' >]+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9d603c60f7149d4391e2f9603f077b8a5dea45eb22517e1fcae98966b0bcc8ed"
    sha256 cellar: :any,                 arm64_sonoma:  "a9f8d5660a11587ceb4f74c36028595bd0f382dec602d5dae67e60394512f1c5"
    sha256 cellar: :any,                 arm64_ventura: "1efac14baca5b829081b4798b3fdad731d667b0076615e0ac92dde5caa08c5e8"
    sha256 cellar: :any,                 sonoma:        "2644519b01f118d98935bb7ef5c6b2205711938d904f548829960cc65229ea5c"
    sha256 cellar: :any,                 ventura:       "77b35a83341fc2faedc0bfa5fe0f925da8e410e76a38e426c720fca917228f02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56043db74438ba802de747ab9c277b5f2521ec4077cd5cd3d70242aa7da18a97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d542cf27b207fe2a8fdd850d5520c00bc70498ea835221a74198e08701c61dd2"
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

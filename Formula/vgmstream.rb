class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://hcs64.com/vgmstream.html"
  url "https://github.com/losnoco/vgmstream.git",
      tag:      "r1050-3280-gba405509",
      revision: "ba405509cc3bb9fe1a6389d6d268475e2d567545"
  license "ISC"
  head "https://github.com/losnoco/vgmstream.git"

  bottle do
    cellar :any
    sha256 "235ded9d960b2a99ceb17630c5cc0aa352b2afbadc90a01439a7ff481f7062bd" => :catalina
    sha256 "584faaf779e7adcd1b8d2243641b80f277314588372f9bd8a137e9c4110b3a9e" => :mojave
    sha256 "c70ca3ae85b5138dbb8d97cadaf459e77633e0b022c2f8c210be05cd2881544b" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg"
  depends_on "libao"
  depends_on "libvorbis"
  depends_on "mpg123"

  def install
    system "cmake", "-DBUILD_AUDACIOUS:BOOL=OFF", "."
    system "make", "vgmstream_cli"
    system "make", "vgmstream123"
    bin.install "cli/vgmstream_cli"
    bin.install_symlink "vgmstream_cli" => "vgmstream-cli"
    bin.install "cli/vgmstream123"
    lib.install "src/liblibvgmstream.a"
  end

  test do
    assert_match "decode", shell_output("#{bin}/vgmstream-cli 2>&1", 1)
  end
end

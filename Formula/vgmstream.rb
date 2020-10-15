class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://hcs64.com/vgmstream.html"
  url "https://github.com/losnoco/vgmstream/archive/r1050-3264-g86fbfffd.tar.gz"
  version "r1050-3264-g86fbfffd"
  sha256 "c7cb968c734b02dcfce46a3abf3486be494a599c238d77c1103c302e91763d11"
  head "https://github.com/kode54/vgmstream.git"

  bottle do
    cellar :any
    sha256 "235ded9d960b2a99ceb17630c5cc0aa352b2afbadc90a01439a7ff481f7062bd" => :catalina
    sha256 "584faaf779e7adcd1b8d2243641b80f277314588372f9bd8a137e9c4110b3a9e" => :mojave
    sha256 "c70ca3ae85b5138dbb8d97cadaf459e77633e0b022c2f8c210be05cd2881544b" => :high_sierra
  end

  depends_on "libao"
  depends_on "libvorbis"
  depends_on "mpg123"

  def install
    system "make", "vgmstream_cli"
    system "make", "vgmstream123"
    bin.install "cli/vgmstream-cli"
    bin.install "cli/vgmstream123"
    lib.install "src/libvgmstream.a"
  end

  test do
    assert_match "decode", shell_output("#{bin}/vgmstream-cli 2>&1", 1)
  end
end

class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://hcs64.com/vgmstream.html"
  url "https://github.com/losnoco/vgmstream/archive/r1050-3086-gc9dc860c.tar.gz"
  version "r1050-3086-gc9dc860c"
  sha256 "dee8b6005db0ea4d1cd8940529bd2fe019fb753b67d1c19ac90df261f264b311"
  head "https://github.com/kode54/vgmstream.git"

  bottle do
    cellar :any
    sha256 "06b1a2c17d2b02de2d9e3580700245141b8bf8e5501e01a5f943d755fbdd9be3" => :catalina
    sha256 "c47f6241f20aa7d9d89e7058a3fc56c844f8b0b622312c4c281393dfa86b9da4" => :mojave
    sha256 "44200141865ea303d35c293028aafb528135e27374a116a63a6b506fa5b60ede" => :high_sierra
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

class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://hcs64.com/vgmstream.html"
  url "https://github.com/losnoco/vgmstream/archive/r1050-3086-gc9dc860c.tar.gz"
  version "r1050-3086-gc9dc860c"
  sha256 "dee8b6005db0ea4d1cd8940529bd2fe019fb753b67d1c19ac90df261f264b311"
  head "https://github.com/kode54/vgmstream.git"

  bottle do
    cellar :any
    sha256 "27cb2df8b0a88d31507695a9b8711bbeca66ac9a09f8e34de399a45b7f2c216a" => :catalina
    sha256 "8a52d5fdc81f87c709c0f41c90b02cba2788f7429402a327fcf343d331346018" => :mojave
    sha256 "513761e04c72ecf6300222bd06d662b7ab0ae74b56f37cc586dcd514e5f2ffc3" => :high_sierra
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

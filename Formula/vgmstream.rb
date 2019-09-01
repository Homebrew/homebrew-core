class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://hcs64.com/vgmstream.html"
  url "https://github.com/losnoco/vgmstream/archive/r1050-2441-gd64c3872.tar.gz"
  version "r1050-2441-gd64c3872"
  sha256 "e1d7dfbf65b9b58ebb8c3c3792f8d7a04de55c03e5292e5ac68de5e60c65587b"
  head "https://github.com/kode54/vgmstream.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "dd7dae465bb50700fcf448c3a5fc0478600c6151eeade7196c88202aa19c2f4f" => :mojave
    sha256 "970428e954d82c2aaef2da083320fabd21ae7ba866fd2055d5fdcdd21f2989b0" => :high_sierra
    sha256 "b85d6942270fc9024de56e4fe08618f7ffce1499f4c9faf3f31b246310a17511" => :sierra
    sha256 "980226be71f7ba16f71e7cd4ba53a4160c03cf9308036d014538b1feb8285d08" => :el_capitan
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

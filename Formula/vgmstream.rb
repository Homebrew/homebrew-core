class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://hcs64.com/vgmstream.html"
  url "https://github.com/kode54/vgmstream/archive/r1040.tar.gz"
  version "r1040"
  sha256 "0ff6534a4049b27b01caf209811b87b1bfe445f94e141a5fe601f2dae9d03c89"
  head "https://github.com/kode54/vgmstream.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "dd7dae465bb50700fcf448c3a5fc0478600c6151eeade7196c88202aa19c2f4f" => :mojave
    sha256 "970428e954d82c2aaef2da083320fabd21ae7ba866fd2055d5fdcdd21f2989b0" => :high_sierra
    sha256 "b85d6942270fc9024de56e4fe08618f7ffce1499f4c9faf3f31b246310a17511" => :sierra
    sha256 "980226be71f7ba16f71e7cd4ba53a4160c03cf9308036d014538b1feb8285d08" => :el_capitan
  end

  depends_on "libvorbis"
  depends_on "mpg123"

  def install
    cd "test" do
      system "make"
      bin.install "test" => "vgmstream"
      lib.install "../src/libvgmstream.a"
    end
  end

  test do
    assert_match "decode", shell_output("#{bin}/vgmstream 2>&1", 1)
  end
end

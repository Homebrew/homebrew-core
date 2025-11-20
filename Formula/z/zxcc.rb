class Zxcc < Formula
  desc "CP/M 2/3 emulator for cross-compiling and CP/M tools under UNIX"
  homepage "https://www.seasip.info/Unix/Zxcc/"
  url "https://www.seasip.info/Unix/Zxcc/zxcc-0.5.7.tar.gz"
  sha256 "6095119a31a610de84ff8f049d17421dd912c6fd2df18373e5f0a3bc796eb4bf"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]

  livecheck do
    url :homepage
    regex(/href=.*?zxcc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "e312260a654050c8776f39d0558ab6c5e9b7d62f4f219475a13dcd8e75fbd759"
    sha256 arm64_sequoia:  "bddad2d64c555a4a13ba9cbc9c0cb6da0f249f6ef360c2274626a8b036c473a3"
    sha256 arm64_sonoma:   "8c8e1b35ae99069026c14d9cf0d35a14196d7be3e0a1e7bdbc9d6ec5fd6f5b13"
    sha256 arm64_ventura:  "e2fe6fa77252015a020de63bb4973171a8b9a9c90f866f2835f1e36e4e5714de"
    sha256 arm64_monterey: "b72dfe0dda214485bb604b56b731e04109c964d10f45eb3b6fedceffdedf61ca"
    sha256 arm64_big_sur:  "3f7d36f3115f3dc9310aa01045a455fe7dab1732612421b5451777c140bf952a"
    sha256 sonoma:         "771d3fa5f8e286a2b0ed1d1e4765a69e348d0352ccadae189cd658a64a5e24b3"
    sha256 ventura:        "08b4d0233886b19e05fdbe3f3bb90d25146716a354bcf7e07d89396ef6b53397"
    sha256 monterey:       "015f6a038fa59edef9b58d8edef90d4ad957c1275e581d2d9e645868b37dc9e1"
    sha256 big_sur:        "55897339c53884d74e51e270e458085e4c1a3c8494b7053d40205d511ae0759a"
    sha256 catalina:       "748648c861049366a5bab8f7a101274da7bd2d2378237ccc4acd4cbd5b60fde1"
    sha256 arm64_linux:    "f03ecace625722887a14453a0a0d9c8901b0eb83e5f61e2f8f774a2002f0c225"
    sha256 x86_64_linux:   "8a5baf11b9060b7aedcf4f25afca690fbad80df406a66a70389ddd32fe2c6075"
  end

  uses_from_macos "ncurses"

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    code = [
      0x11, 0x0b, 0x01,   # 0100 ld de,010bh
      0x0e, 0x09,         # 0103 ld c,cwritestr
      0xcd, 0x05, 0x00,   # 0105 call bdos
      0xc3, 0x00, 0x00,   # 0108 jp warm
      0x48, 0x65, 0x6c,   # 010b db "Hel"
      0x6c, 0x6f, 0x24    # 010e db "lo$"
    ].pack("c*")

    path = testpath/"hello.com"
    path.binwrite code

    assert_equal "Hello", shell_output("#{bin}/zxcc #{path}").strip
  end
end

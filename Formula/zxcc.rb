class Zxcc < Formula
  desc "CP/M 2/3 emulator for cross-compiling and CP/M tools under UNIX"
  homepage "https://www.seasip.info/Unix/Zxcc/"
  url "https://www.seasip.info/Unix/Zxcc/zxcc-0.5.7.tar.gz"
  sha256 "6095119a31a610de84ff8f049d17421dd912c6fd2df18373e5f0a3bc796eb4bf"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?zxcc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "e2fe6fa77252015a020de63bb4973171a8b9a9c90f866f2835f1e36e4e5714de"
    sha256 arm64_monterey: "b72dfe0dda214485bb604b56b731e04109c964d10f45eb3b6fedceffdedf61ca"
    sha256 arm64_big_sur:  "3f7d36f3115f3dc9310aa01045a455fe7dab1732612421b5451777c140bf952a"
    sha256 ventura:        "08b4d0233886b19e05fdbe3f3bb90d25146716a354bcf7e07d89396ef6b53397"
    sha256 monterey:       "015f6a038fa59edef9b58d8edef90d4ad957c1275e581d2d9e645868b37dc9e1"
    sha256 big_sur:        "55897339c53884d74e51e270e458085e4c1a3c8494b7053d40205d511ae0759a"
    sha256 catalina:       "748648c861049366a5bab8f7a101274da7bd2d2378237ccc4acd4cbd5b60fde1"
    sha256 mojave:         "3d0cb9741bb9f9ab8f8f6db1452c2c052814b5aa3b37971607e91c5ba40bd9ae"
    sha256 high_sierra:    "0b6a6d166b5b4822b46d8a53b0a2b850619882d9d13080ecdad8b0ae492a5cc0"
    sha256 sierra:         "79aa0631d52d2d69ae554319db0027ffd59f2baa3d1c35473925f72a5c1965e3"
    sha256 el_capitan:     "11bd1697b8a6b5a3a77ce417d35ad7e1da9e6df18a36ebccfa18a47ce470d3cb"
    sha256 x86_64_linux:   "8a5baf11b9060b7aedcf4f25afca690fbad80df406a66a70389ddd32fe2c6075"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
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

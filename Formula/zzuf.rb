class Zzuf < Formula
  desc "Transparent application input fuzzer"
  homepage "http://caca.zoy.org/wiki/zzuf"
  url "https://github.com/samhocevar/zzuf/releases/download/v0.15/zzuf-0.15.tar.bz2"
  sha256 "04353d94c68391b3945199f100ab47fc5ff7815db1e92581a600d4175e3a6872"

  bottle do
    sha256 "809edd89cf9bd285a0f5496500627aca8b4b4cec071bfd747eb7ae3918526ae6" => :catalina
    sha256 "43c9049f2ff8d13a585009b43923579c087e0797a8d0258fc891be14f3ce6ce9" => :mojave
    sha256 "f13b52915de3bf08ed663b02df0f8b4d8f78d3a623c523a4d5f3c085ae6bafcf" => :high_sierra
    sha256 "9f1b2bfb909739bc5dec2e56b520313e30df3384e8a249b575d3664ac6a636be" => :sierra
    sha256 "5f0c55658fba6bbf225b6001b5be75c38f7a375322bd4b23944f3c7239dae0c7" => :el_capitan
    sha256 "7f260ec41af74aa8b99df4a89f202382c72067e34b4bb3ac0a0e3fb0be6f8ed0" => :yosemite
    sha256 "52460ee4dcac540298fa8f0e07225bc01d5592fd4ff558f1cfd129b329e87639" => :mavericks
  end

  head do
    url "https://github.com/samhocevar/zzuf.git"

    depends_on "autoconf"   => :build
    depends_on "automake"   => :build
    depends_on "libtool"    => :build
    depends_on "pkg-config" => :build
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/zzuf -i -B 4194304 -r 0.271828 -s 314159 -m < /dev/zero").chomp
    assert_equal "zzuf[s=314159,r=0.271828]: 549e1200590e9c013e907039fe535f41", output
  end
end

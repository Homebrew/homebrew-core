class Zzuf < Formula
  desc "Transparent application input fuzzer"
  homepage "http://caca.zoy.org/wiki/zzuf"
  url "https://github.com/samhocevar/zzuf/releases/download/v0.15/zzuf-0.15.tar.bz2"
  sha256 "04353d94c68391b3945199f100ab47fc5ff7815db1e92581a600d4175e3a6872"
  license "WTFPL"

  bottle do
    sha256                               arm64_ventura:  "16fc98439ca072e8cf19c129649eff99e63e0cece1c1455e97f04ce7cb4dfd73"
    sha256                               arm64_monterey: "8cf189e969a94737e6729be772df9f64759b7c33580cee51d571b31365dbddf2"
    sha256                               arm64_big_sur:  "7ff801dd276cdd8f830d07d01c97a83207ed8ac77c6023ff21b29a2ec536637b"
    sha256                               ventura:        "397eb044876f87b27787679b9a8f965da0aca9251386aa2a6dbbd1b5ef8cd3c9"
    sha256                               monterey:       "2cfa284477cd1e81ac3b248a20f25812083fe7b592a997ecbefee7663cedab91"
    sha256                               big_sur:        "284b235c4c744d7be86fbe6175a8d67a743a429c8021437182a31e6184105437"
    sha256                               catalina:       "809edd89cf9bd285a0f5496500627aca8b4b4cec071bfd747eb7ae3918526ae6"
    sha256                               mojave:         "43c9049f2ff8d13a585009b43923579c087e0797a8d0258fc891be14f3ce6ce9"
    sha256                               high_sierra:    "f13b52915de3bf08ed663b02df0f8b4d8f78d3a623c523a4d5f3c085ae6bafcf"
    sha256                               sierra:         "9f1b2bfb909739bc5dec2e56b520313e30df3384e8a249b575d3664ac6a636be"
    sha256                               el_capitan:     "5f0c55658fba6bbf225b6001b5be75c38f7a375322bd4b23944f3c7239dae0c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7164c38ad977edfad3d137b9071e22f185effde9165996e847facd20f4df0e65"
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

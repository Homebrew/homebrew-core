class Zzuf < Formula
  desc "Transparent application input fuzzer"
  homepage "http://caca.zoy.org/wiki/zzuf"
  url "https://github.com/samhocevar/zzuf/releases/download/v0.15/zzuf-0.15.tar.bz2"
  sha256 "04353d94c68391b3945199f100ab47fc5ff7815db1e92581a600d4175e3a6872"

  bottle do
    sha256 "a713556c18e8b3415bd4b8ee19e501f7764c15a7fc7c907eefeb09afc582ba5b" => :el_capitan
    sha256 "1a392bd97e6aaf5688d675d45f998d2b49a123c38e0bd4a5bee1f274644fc106" => :yosemite
    sha256 "a624ccb43655ab0ae5a78721f08a05fb8ffe0d6cecbfae3e07e088cd6a5b8315" => :mavericks
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

class Wy60 < Formula
  desc "Wyse 60 compatible terminal emulator"
  homepage "https://code.google.com/archive/p/wy60/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/wy60/wy60-2.0.9.tar.gz"
  sha256 "f7379404f0baf38faba48af7b05f9e0df65266ab75071b2ca56195b63fc05ed0"

  bottle do
    sha256 arm64_big_sur: "700b80eb03a92465ae6a0860bf3c3eb572c9bc97799eec577e2fcb694c050148"
    sha256 big_sur:       "d9f755155083e888e0c001dc6590e88f90c5c1ae7868d7ec36865e127f60e066"
    sha256 catalina:      "29247a3617870bdb8364f9ce1b6d167b6029b016683dc5da39816b0a637bf5ef"
    sha256 mojave:        "04e34b5cc12f3c130454dec804ff989e999fe6fb043c66f44976fc710fdce62a"
    sha256 high_sierra:   "77fb48cc35956863e1f685b41c885337ca770185edffb250cbed8bd8c5a3070b"
    sha256 sierra:        "f03706d166cfcc0679e696493bd13df30ad0617a92b602b79e3494ba3b1f46fb"
    sha256 el_capitan:    "84d3bfa45582f2816808006f192c7580cedad24de3941a0786b5b36ce29e469c"
    sha256 yosemite:      "80508e33f12142eec20ff0e8866ed191b03facea5b6653a6f5331cb017ff78af"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wy60", "--version"
  end
end

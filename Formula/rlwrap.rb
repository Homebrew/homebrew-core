class Rlwrap < Formula
  desc "Readline wrapper: adds readline support to tools that lack it"
  homepage "https://github.com/hanslub42/rlwrap"
  url "https://github.com/hanslub42/rlwrap/archive/v0.45.1.tar.gz"
  sha256 "ed9a198191685efcd2f68a9071b9c65b8705f81f2f6bea935032b3f92860bde7"
  license "GPL-2.0-or-later"
  head "https://github.com/hanslub42/rlwrap.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "e554125cd5514710000e5e136d1b7716eeadc45e8ea39c5e8c34f2eee4ae0149"
    sha256 big_sur:       "5aa36fd44d1c68156a84976aed20853c622adce1191284aad551688609b997c8"
    sha256 catalina:      "f44bcd80462e7db08a7e7312a76252a14f92dc387b073ec8ec3787beb79a78d6"
    sha256 mojave:        "92c8c3488cb36b079f6ea9781724f1b86c9a9feb7aac6728be0e06eaec16cdf7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "readline"

  def install
    system "autoreconf", "-v", "-i"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rlwrap", "--version"
  end
end

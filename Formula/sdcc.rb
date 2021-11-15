class Sdcc < Formula
  desc "ANSI C compiler for Intel 8051, Maxim 80DS390, and Zilog Z80"
  homepage "https://sdcc.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sdcc/sdcc/4.1.0/sdcc-src-4.1.0.tar.bz2"
  sha256 "81edf776d5a2dc61a4b5c3408929db7b25874d69c46e4a71b116be1322fd533f"
  license all_of: ["GPL-2.0-only", "GPL-3.0-only", :public_domain, "Zlib"]
  head "https://svn.code.sf.net/p/sdcc/code/trunk/sdcc"

  livecheck do
    url :stable
    regex(%r{url=.*?/sdcc-src[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "cdbba6dcec050612f65b0cdaf28d0cb10f26e9090e208ee4e43bd1f95b83b243"
    sha256 arm64_big_sur:  "204b16ac599b7a7c4f881f5689b47f3af4d09134b63686c716f42751e192c1ff"
    sha256 monterey:       "62b6882a1689b65133f962bbb33ecafd875a0369206b0ac57d25dc62a8d42663"
    sha256 big_sur:        "3b9371b349c03c7628b68b103f5f49fb7861c0662d9f092a9013f6441b43b2ed"
    sha256 catalina:       "546c39fb908ac27107a59f8427848161e0573c36e17199acddd1e4b839f37c9f"
    sha256 mojave:         "ed31251e97c22718ffd714b06561cba755cce2030d0213324fe986e1bf0b8137"
    sha256 x86_64_linux:   "249aea9a8895f2081ad2de9b845c81c40c8afaba690f5371f4d2ecfdda552703"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"
  depends_on "gputils"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "texinfo" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "all"
    system "make", "install"
    rm Dir["#{bin}/*.el"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main() {
        return 0;
      }
    EOS
    system "#{bin}/sdcc", "-mz80", "#{testpath}/test.c"
    assert_predicate testpath/"test.ihx", :exist?
  end
end

class Sdcc < Formula
  desc "ANSI C compiler for Intel 8051, Maxim 80DS390, and Zilog Z80"
  homepage "https://sdcc.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sdcc/sdcc/4.2.0/sdcc-src-4.2.0.tar.bz2"
  sha256 "b49bae1d23bcd6057a82c4ffe5613f9cd0cbcfd1e940e9d84c4bfe9df0a8c053"
  license all_of: ["GPL-2.0-only", "GPL-3.0-only", :public_domain, "Zlib"]
  head "https://svn.code.sf.net/p/sdcc/code/trunk/sdcc"

  livecheck do
    url :stable
    regex(%r{url=.*?/sdcc-src[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "88f61b9b2848b0c6e21af0f3e107ecbfd806ef1a4c4d734a2066a76f375d51f4"
    sha256 arm64_big_sur:  "098d09285da054f19228ec62cbb47fbabb0a2ec64c74aa42ce1785af8671c13d"
    sha256 monterey:       "5278115376a14cbe879ec0bc8145ab276d11891b8230664d3180d84f5cc75d6d"
    sha256 big_sur:        "45ca54b6bff16c5282f935a0bda39e6164adfc790e3f073d860a2caab554f7d8"
    sha256 catalina:       "078203da744fc5169e80022e7cd541938fb64a993606c1fc0a16076da70436a6"
    sha256 x86_64_linux:   "3bfa7da54ce11de99acdb5782963b3e7b9dfbeb2fa8ab55a9155fada408f2691"
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

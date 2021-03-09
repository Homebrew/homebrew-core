class Sdcc < Formula
  desc "ANSI C compiler for Intel 8051, Maxim 80DS390, and Zilog Z80"
  homepage "https://sdcc.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sdcc/sdcc/4.0.0/sdcc-src-4.0.0.tar.bz2"
  sha256 "489180806fc20a3911ba4cf5ccaf1875b68910d7aed3f401bbd0695b0bef4e10"
  license all_of: ["GPL-2.0-only", "GPL-3.0-only", :public_domain, "Zlib"]
  revision 1
  head "https://svn.code.sf.net/p/sdcc/code/trunk/sdcc"

  livecheck do
    url :stable
    regex(%r{url=.*?/sdcc-src[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_big_sur: "384195a1fe4a6b681b54a6a5cb93d1da698ef1f7ed4ef34b1b1ba92b52b8e406"
    sha256 big_sur:       "705bf57ac5c173a893408644a2fb69fd9c6941cb44fe3ea17b5ea44ca4afc4b3"
    sha256 catalina:      "b99efe742281c6aa552426b782cf9c372df35e60ef01a65980d4b53071f8581e"
    sha256 mojave:        "9c2bbf7462ef3b3fa92701e11c9a58b497d3814159aea69933d8ff674b4fa40f"
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

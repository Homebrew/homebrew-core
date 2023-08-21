class Sdcc < Formula
  desc "ANSI C compiler for Intel 8051, Maxim 80DS390, and Zilog Z80"
  homepage "https://sdcc.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/sdcc/sdcc/4.3.0/sdcc-src-4.3.0.tar.bz2"
  sha256 "2a6fc0f021080103daf393ac0efea8ce0f5e9fe2140dce30b999282c81c893cd"
  license all_of: ["GPL-2.0-only", "GPL-3.0-only", :public_domain, "Zlib"]
  head "https://svn.code.sf.net/p/sdcc/code/trunk/sdcc"

  livecheck do
    url :stable
    regex(%r{url=.*?/sdcc-src[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "952ba3d58978fe2df751a1689baa98996f17974b44dcef75c55b536290fe25eb"
    sha256 arm64_monterey: "051d43d9d6fa0b087f3c12add6234ac539e320a26c96f262fe091d999a2bb35f"
    sha256 arm64_big_sur:  "3a30b3643849d2509ec7ee0ba3f4b9d65020cf60f2881a6347a0a1bcd378db54"
    sha256 ventura:        "03964a8f18c071fe70922e7b9d9e9109c99ef0dbbef0f73dd6a261ba716e3293"
    sha256 monterey:       "cd7f93d2ffda42a6676b79bdcb71d81354da6924f6e540cd524ae0d53f9f5bc4"
    sha256 big_sur:        "3cdab5e848de0fde645e2afb85f0c1fc79a83798c2bb632d6903f2972ae00e1d"
    sha256 x86_64_linux:   "cd11da769aff6397da965da3fb438704e4c4c7c140ab78cb035154b564f2a2b5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"
  depends_on "gputils"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

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

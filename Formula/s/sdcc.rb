class Sdcc < Formula
  desc "ANSI C compiler for Intel 8051, Maxim 80DS390, and Zilog Z80"
  homepage "https://sdcc.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/sdcc/sdcc/4.4.0/sdcc-src-4.4.0.tar.bz2"
  sha256 "ae8c12165eb17680dff44b328d8879996306b7241efa3a83b2e3b2d2f7906a75"
  license all_of: ["GPL-2.0-only", "GPL-3.0-only", :public_domain, "Zlib"]
  head "https://svn.code.sf.net/p/sdcc/code/trunk/sdcc"

  livecheck do
    url :stable
    regex(%r{url=.*?/sdcc-src[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "1b9ecefe9331bd7932a5b277188f2c05bab3d883bd22e0210336ce070a068b96"
    sha256 arm64_ventura:  "a3feae25c1dc7b0e760862cdcea40bf246bb8367fb7e32713d60a72ca67b0198"
    sha256 arm64_monterey: "b8d1facd553ec7e49cfe80d7ab70e81c89bed40920e82bf4dd02c5b93b1053ab"
    sha256 sonoma:         "9e7802e6ad9355271be8782121f5ac27fa4de082f82e010f24e136eafc08d764"
    sha256 ventura:        "473634c817b54b4709c3579e571c4005eb6ae4d856114f6c85bc2f271e5a1ade"
    sha256 monterey:       "470dc349d2a3e87b91d0874d788199d31cbb1a2d8e74d2e98013cd11e67ea8fb"
    sha256 x86_64_linux:   "41d0b195b867e851a31290fa8d2b51a5f53f47ae0873d7dc3ca54e6442219fc2"
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
    system bin/"sdcc", "-mz80", "#{testpath}/test.c"
    assert_predicate testpath/"test.ihx", :exist?
  end
end

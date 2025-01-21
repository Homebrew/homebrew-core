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
    rebuild 1
    sha256 arm64_sequoia: "c820ee7d47b15c893f034833e48d7f031d358203f01f7e0103a3e3c0ab82f241"
    sha256 arm64_sonoma:  "81c0b441730890c79c4d3485e73b9e71e4ad5d634a53f243969f209f36d2b327"
    sha256 arm64_ventura: "aa82c793aed1656d4dfc86c3dd1b9991c3f8fd404650b9d79a830c98ef9bd12d"
    sha256 sonoma:        "b260a444278d16f818706fa08567143b966bf98ba70a466c58fa3f7116cd58db"
    sha256 ventura:       "71c542578133d8caa260042424fb5e0d3ad861da5f3114cecf22d39b7c1d078c"
    sha256 x86_64_linux:  "13d055d8246179d6ef18d6e91d96e4da3e77493476b4992c57880bef0f66e472"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost" => :build
  depends_on "gputils"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  on_macos do
    depends_on "zstd"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    system "./configure", "--disable-non-free", "--without-ccache", *std_configure_args
    system "make", "install"
    elisp.install bin.glob("*.el")
  end

  test do
    (testpath/"test.c").write <<~C
      int main() {
        return 0;
      }
    C
    system bin/"sdcc", "-mz80", "#{testpath}/test.c"
    assert_predicate testpath/"test.ihx", :exist?
  end
end

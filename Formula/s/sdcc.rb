class Sdcc < Formula
  desc "ANSI C compiler for Intel 8051, Maxim 80DS390, and Zilog Z80"
  homepage "https://sdcc.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/sdcc/sdcc/4.5.0/sdcc-src-4.5.0.tar.bz2"
  sha256 "d5030437fb436bb1d93a8dbdbfb46baaa60613318f4fb3f5871d72815d1eed80"
  license all_of: ["GPL-2.0-only", "GPL-3.0-only", :public_domain, "Zlib"]
  head "https://svn.code.sf.net/p/sdcc/code/trunk/sdcc"

  livecheck do
    url :stable
    regex(%r{url=.*?/sdcc-src[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "7ff34d8aaf315983a7f5da110b4851625964d4886f04d1f3aff780bb0cf99c15"
    sha256 arm64_sequoia: "8a5ba597acf12b5d1035666984b1ee68bbe732957ef7d4db046e3259298519c2"
    sha256 arm64_sonoma:  "730449a156f828dabdb32497504d9e014207648c93064516648af3bb3c19f59f"
    sha256 arm64_ventura: "3c7396176a31c4ed07f70ee1bf32b7cff2e27de40f382cd5208dbb2dd6a5134f"
    sha256 sonoma:        "1f1004c896b885aa65e33c71530906f085f81241a5ca3f42737a252dcff22200"
    sha256 ventura:       "babe449f182d8d1a8ee922b2ca74d7a7bcfe55d2c85133d356ed80c03c4ae49a"
    sha256 arm64_linux:   "c8462d05395dfcd9c0b18ba670cbf28a19bd771af37352b55fa49e56ee297832"
    sha256 x86_64_linux:  "93079cad266875209f9c852f8f06da7b4c5e1975b4cf0719f33925af508d9f0e"
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
    assert_path_exists testpath/"test.ihx"
  end
end

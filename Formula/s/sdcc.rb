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
    rebuild 1
    sha256 arm64_tahoe:   "42efbd33b94c29841d06d3e55dcdaca4d15c580283cafa557bcaa897d229c383"
    sha256 arm64_sequoia: "d20234031c26f6ce70e990137707f6efdb58f44f0937874cec4ea58c02957a75"
    sha256 arm64_sonoma:  "b33d78cfa452a144e36cb97e7fa6a21f4bb190d54db6bb66cb93a7dfc3f56661"
    sha256 sonoma:        "923eff6fa7522d6ef4bb001edb69ed9372b8eb55a143f8f1b392b2ef82604719"
    sha256 arm64_linux:   "52df93b8ad9113b0a8c560a1702c58f2743e1e39ddba31de70316446a34d9f5c"
    sha256 x86_64_linux:  "93e44c24cbcd84f457b2e496d544261a4dfbd146824d36b6f86542727f570bae"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost" => :build
  depends_on "gputils"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_macos do
    depends_on "zstd"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
    system bin/"sdcc", "-mz80", testpath/"test.c"
    assert_path_exists testpath/"test.ihx"
  end
end

class Sdcc < Formula
  desc "ANSI C compiler for Intel 8051, Maxim 80DS390, and Zilog Z80"
  homepage "https://sdcc.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/sdcc/sdcc/4.6.0/sdcc-src-4.6.0.tar.bz2"
  sha256 "5fd6a93e5997ce01756868fe35e441095cfb637894a80c262514a634094973b6"
  license all_of: [
    "GPL-2.0-or-later", # sdcc, sdcdb, ucsim
    "GPL-3.0-or-later", # sdcpp, sdas, sdld, sdbinutils
    :public_domain,     # packihx
    "Zlib",             # makebin
  ]
  revision 1
  head "https://svn.code.sf.net/p/sdcc/code/trunk/sdcc"

  livecheck do
    url :stable
    regex(%r{url=.*?/sdcc-src[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "37dfb62fc92f063a5ef482b2872c2943a02db6b8101207ef27a5368cdce24c07"
    sha256 arm64_tahoe:       "0e768549a12987be316142abbf9e2a9d7a3d9cfd29896152f0a5e20f602eda2c"
    sha256 arm64_sequoia:     "5f0e5cc88c1481d32c3c6b034143bff0011c78b9dd8e3ccd196e2f8a76e8cac6"
    sha256 arm64_linux:       "876ce7ee8975df84fb5fd2339e955f28439a435ddffa06657140ee83ea9b5f3e"
    sha256 x86_64_linux:      "15ffb6a5bb6d3d149f6d6fc1c841361990914374127a738f84074aff1ea403cb"
  end

  depends_on "boost" => :build
  depends_on "binutils" => :test # to check for conflicts
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
    args = %w[
      --disable-install-libbfd
      --disable-nls
      --disable-non-free
      --without-ccache
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
    elisp.install bin.glob("*.el")
    # FIXME: sdbinutils prefixes every tool except the demangler, which clashes with `binutils`
    mv bin/"c++filt", bin/"sdc++filt"
    # Remove info files that are part of binutils
    rm_r(info)
  end

  test do
    (testpath/"test.c").write <<~C
      int main() {
        return 0;
      }
    C
    system bin/"sdcc", "-mz80", testpath/"test.c"
    assert_match "main()", shell_output("#{bin}/sdc++filt _Z4mainv")
    assert_path_exists testpath/"test.ihx"
  end
end

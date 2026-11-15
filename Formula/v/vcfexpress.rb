class Vcfexpress < Formula
  desc "Filter and format VCF/BCF files with Lua expressions"
  homepage "https://github.com/brentp/vcfexpress"
  url "https://github.com/brentp/vcfexpress/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "c1f7e1c15a73f3e1718f9d2c49aef7feb0c8ac7a5db3df7c3d8ce2ce84e54b8c"
  license "MIT"
  head "https://github.com/brentp/vcfexpress.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "75432627cbb9d543e3c848abc92a1d40f70006cde998b4b174fa9a94ecaf789b"
    sha256 cellar: :any, arm64_tahoe:       "6b65c491b553924d74a27e75da784a7b07727e62dfb5dae317775111daded837"
    sha256 cellar: :any, arm64_sequoia:     "0f4758a5a7c398eaf4243ba120eb87c61c21d8ae6ebc2db2156149f502f6c215"
    sha256 cellar: :any, arm64_linux:       "bb5d365842acbf22398b01bccf7faf3c96f2ecad77fc6f0912b420ec90b901b0"
    sha256 cellar: :any, x86_64_linux:      "1a875cb6689a635521ee24f64ce0b0edaebeafae1494aa0a2eaf62639710fe94"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  uses_from_macos "llvm" => :build # for `libclang`, used by `hts-sys` bindgen
  uses_from_macos "bzip2"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm") if OS.linux?
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"in.vcf").write <<~EOS
      ##fileformat=VCFv4.2
      ##contig=<ID=chr1,length=1000>
      ##INFO=<ID=DP,Number=1,Type=Integer,Description="Depth">
      #CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO
      chr1\t100\trs1\tA\tG\t50\tPASS\tDP=5
      chr1\t200\trs2\tC\tT\t50\tPASS\tDP=40
      chr1\t300\trs3\tG\tA\t50\tPASS\tDP=60
    EOS

    system bin/"vcfexpress", "filter", "-e", "return variant:info('DP') > 30",
           "--template", "{variant.id}\\t{variant.start}", "-o", "out.tsv", "in.vcf"
    assert_equal "rs2\t199\nrs3\t299\n", (testpath/"out.tsv").read

    assert_match version.to_s, shell_output("#{bin}/vcfexpress --version")
  end
end

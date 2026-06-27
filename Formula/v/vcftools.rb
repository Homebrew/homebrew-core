class Vcftools < Formula
  desc "Tools for working with VCF files"
  homepage "https://vcftools.github.io/"
  url "https://github.com/vcftools/vcftools/releases/download/v0.1.17/vcftools-0.1.17.tar.gz"
  sha256 "b9e0e1c3e86533178edb35e02c6c4de9764324ea0973bebfbb747018c2d2a42c"
  license "LGPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f628a8d64c2eef1dad37e8c4f74ebe84029e88b6098266085ad3e90802a71f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3951341670d6519250d8d09cf76707d7acc47dccd7d88b7b5fd104016eb240d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8a9fdf5d69e89f4655f32901c739196746b0a3339b3f9afcf4295d5bc739830"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca8e6beee74be0ab28d3e157f639e304cf6466621d3b075484abf813da706f7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd5e186291430a0211b96f314e128cedb8bbac12ff3528a69e3c8ab8e5d6046a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "208f9816c84abebadc3e94a42e3d3970ae2e303f4bee9afc390545455e7c4810"
  end

  depends_on "pkgconf" => :build
  depends_on "htslib"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--with-pmdir=lib/perl5/site_perl",
                          *std_configure_args
    system "make", "install"

    bin.env_script_all_files(libexec/"bin", PERL5LIB: lib/"perl5/site_perl")
  end

  test do
    (testpath/"test.vcf").write <<~EOS
      ##fileformat=VCFv4.0
      #CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO
      1	1	.	A	C	10	PASS	.
    EOS

    system bin/"vcf-validator", "test.vcf"
  end
end

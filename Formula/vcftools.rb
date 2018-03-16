class Vcftools < Formula
  desc "Tools for working with VCF files"
  homepage "https://vcftools.github.io/"
  url "https://github.com/vcftools/vcftools/releases/download/v0.1.15/vcftools-0.1.15.tar.gz"
  sha256 "31e47afd5be679d89ece811a227525925b6907cce4af2c86f10f465e080383e3"

  bottle do
    cellar :any_skip_relocation
    sha256 "8885f5eb915bd7bd7b270b421d23aa3b9b600f53e009ddb02ead70ec1a7d7488" => :high_sierra
    sha256 "39f16509c8bd0f394044ea8a9f59e10c7764c1289975f6c0de6b1a4e2bd630ae" => :sierra
    sha256 "d93943d5f24309df2165ea3dd507c4b00b75ef166d0b99a55e8244f98eb2bfbc" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "htslib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-pmdir=lib/perl5/site_perl"
    system "make", "install"

    bin.env_script_all_files(libexec/"bin", :PERL5LIB => lib/"perl5/site_perl")
  end

  test do
    (testpath/"test.vcf").write <<~EOS
      ##fileformat=VCFv4.0
      #CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO
      1	1	.	A	C	10	PASS	.
    EOS
    system "#{bin}/vcf-validator", "test.vcf"
  end
end

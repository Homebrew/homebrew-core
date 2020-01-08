class Vcftools < Formula
  desc "Tools for working with VCF files"
  homepage "https://vcftools.github.io/"
  url "https://github.com/vcftools/vcftools/releases/download/v0.1.16/vcftools-0.1.16.tar.gz"
  sha256 "dbfc774383c106b85043daa2c42568816aa6a7b4e6abc965eeea6c47dde914e3"

  bottle do
    cellar :any_skip_relocation
    sha256 "96424c5e9810127b9f450a88fd314eb94662b35ac88aee4c7efbc8f5420dd989" => :catalina
    sha256 "5d52f2eafbf96fcffd2b8f9804c2d0ca9752af4242c27ed5fe15a6f8cb935498" => :mojave
    sha256 "2fc4ca7c7c23841a1eed8539910737b5986079be6d22d1ff8375f052266bf478" => :high_sierra
    sha256 "32c81874b5d34dee1e36f2dd628cb7eaba8ecef3d612985d7c02c61d6790c5b6" => :sierra
    sha256 "866bc9927660b97ae5bc34dc38db397212163ab289b3284db2d8c610b2aff3d4" => :el_capitan
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

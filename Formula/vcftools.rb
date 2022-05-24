class Vcftools < Formula
  desc "Tools for working with VCF files"
  homepage "https://vcftools.github.io/"
  url "https://github.com/vcftools/vcftools/releases/download/v0.1.16/vcftools-0.1.16.tar.gz"
  sha256 "dbfc774383c106b85043daa2c42568816aa6a7b4e6abc965eeea6c47dde914e3"
  license "LGPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3a70236094425a28dcebf4a60b84cc793c2e55e4198d0f40f25005cb8c33f86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02952054dace13adf39f6621591af9c8c33598334dda6c43948fab1e43916239"
    sha256 cellar: :any_skip_relocation, monterey:       "8a571823e4f66cb7bd7bf3e8ad91129c5e3ed844f4d9d1f4f4eaca60eb19b23e"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd610cf54b51ec2ec429edfab36b2cf1b3eb14787ab0ef5ff9d805def8c48cb0"
    sha256 cellar: :any_skip_relocation, catalina:       "96424c5e9810127b9f450a88fd314eb94662b35ac88aee4c7efbc8f5420dd989"
    sha256 cellar: :any_skip_relocation, mojave:         "5d52f2eafbf96fcffd2b8f9804c2d0ca9752af4242c27ed5fe15a6f8cb935498"
    sha256 cellar: :any_skip_relocation, high_sierra:    "2fc4ca7c7c23841a1eed8539910737b5986079be6d22d1ff8375f052266bf478"
    sha256 cellar: :any_skip_relocation, sierra:         "32c81874b5d34dee1e36f2dd628cb7eaba8ecef3d612985d7c02c61d6790c5b6"
    sha256 cellar: :any_skip_relocation, el_capitan:     "866bc9927660b97ae5bc34dc38db397212163ab289b3284db2d8c610b2aff3d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12d75148c3b77914e113d975b122966b5936d05870330f66dc7aa6dc81def2f0"
  end

  depends_on "pkg-config" => :build
  depends_on "htslib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-pmdir=lib/perl5/site_perl"
    system "make", "install"

    bin.env_script_all_files(libexec/"bin", PERL5LIB: lib/"perl5/site_perl")
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

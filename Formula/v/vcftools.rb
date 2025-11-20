class Vcftools < Formula
  desc "Tools for working with VCF files"
  homepage "https://vcftools.github.io/"
  url "https://github.com/vcftools/vcftools/releases/download/v0.1.17/vcftools-0.1.17.tar.gz"
  sha256 "b9e0e1c3e86533178edb35e02c6c4de9764324ea0973bebfbb747018c2d2a42c"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0b552db414a764f26d3c91714e2fb2cc4711cb0d5e55bbdd063773eaf765ec0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "241688b646045d5427f84c0648839563ae007188dc724b11e75b9bd02a21aef3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be6b8bad02dbcd148cede55aa64faef15f37fc232957c663f7726707754955f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "352df490e413cc6dc659bca5ddb0fa6f4875471593ebc8877f92a265da6a29c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca95fbb22ea7a18e989e5d939026e235a4cd368fe21836db529fdc2ac148554a"
    sha256 cellar: :any_skip_relocation, ventura:       "db860e18120257d1a4da7bcfd454b072c63af840398ef75c25b7115039954e8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1f4780fa49479f742e3ff4c9a56f628c5bb89158f78f88172b450b78a7bbe8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fffa5c3dcaf6f4f200c540e6d1bd4944c9e3840756c190dfcbbe787f2bd164e"
  end

  depends_on "pkgconf" => :build
  depends_on "htslib"

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

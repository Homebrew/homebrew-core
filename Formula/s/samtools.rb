class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.25/samtools-1.25.tar.bz2"
  sha256 "8bbd2b3cb447953149a74ab0b00e3ec4e88a789a27b8373a31fa6b5b2dee02b1"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c7d4f2a00b5e769a8674b5a515665786af7d5551352b51092c0b78c67f5c9b0f"
    sha256 cellar: :any, arm64_tahoe:       "0957908dcf06a7b52629ed06aa6cc9627e02bb1afaab1d0efbc7f9780c2b4672"
    sha256 cellar: :any, arm64_sequoia:     "2eeb0091bba04d3bd38e4f72325f8f4fafad4936f8871e756ccb94b3a67ee220"
    sha256 cellar: :any, arm64_linux:       "46c6eb1108e1f479211eaa5e509f4d66c0d926bc07a1f1c08722376e87cbf3df"
    sha256 cellar: :any, x86_64_linux:      "b02b9577d79e69f3b651a282cf4553920084a46db486024aa45a9475c4f98898"
  end

  depends_on "htslib"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-htslib=#{formula_opt_prefix("htslib")}"
    system "make", "install"
  end

  test do
    (testpath/"test.fasta").write <<~FASTA
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    FASTA
    system bin/"samtools", "faidx", "test.fasta"
    assert_equal "U00096.2:1-70\t70\t15\t70\t71\n", (testpath/"test.fasta.fai").read
  end
end

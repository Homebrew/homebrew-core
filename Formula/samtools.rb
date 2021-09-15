class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.13/samtools-1.13.tar.bz2"
  sha256 "616ca2e051cc8009a1e9c01cfd8c7caf8b70916ddff66f3b76914079465f8c60"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "64ba3681aa336bc479161e887c7eb84bd84a7424529a783db9b23a61bffb71ef"
    sha256 cellar: :any,                 big_sur:       "98634d489c88407d061c93da8b5865da65e36fd40e4a08ae505381ffb1b9fa52"
    sha256 cellar: :any,                 catalina:      "4b4ba1ac799d038a0df5fecd446ab6ad4e331e6682ce4a372b893b91d07f3ada"
    sha256 cellar: :any,                 mojave:        "05287c31f59b12f136c3da0f84cfe2be5c59275a3f66163736e11d231839e111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b4d7af3be41b01c7697992e31dc1f4d289e440e3c34da87e5064552f69e4afe"
  end

  depends_on "htslib"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-htslib=#{Formula["htslib"].opt_prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    system bin/"samtools", "faidx", "test.fasta"
    assert_equal "U00096.2:1-70\t70\t15\t70\t71\n", (testpath/"test.fasta.fai").read
  end
end

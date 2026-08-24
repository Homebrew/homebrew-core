class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.24/samtools-1.24.tar.bz2"
  sha256 "89b2a440123eeaa400392ce1736e7d60ce9041843027d76819753c5a8246bfdd"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e5b5532f7fb77d5259a1ccabf994ab41bb4d5b6628b3ab4bd29e08fe8cfaef4d"
    sha256 cellar: :any, arm64_sequoia: "aab63e19607149514480473923080763d5f063a1b536ba456889ec16adcfffa0"
    sha256 cellar: :any, arm64_sonoma:  "d8d5eb312d480ff40d8b600734aaa5dbcc9ee1a9a33082c2e589f18ef6b7687a"
    sha256 cellar: :any, sonoma:        "7d5c7ce46ece932084cf447309c546d04f13d495460ec021b036619bb09a7076"
    sha256 cellar: :any, arm64_linux:   "c97b56aaa593dc235256bd00e4e2926dcb8acd855ddfc98abe43299b429ce482"
    sha256 cellar: :any, x86_64_linux:  "0cdb1b78d52e279dbb0aa73705d28059a2855887290d58320c5a7e7353dda8d1"
  end

  depends_on "htslib"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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

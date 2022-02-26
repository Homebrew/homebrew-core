class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.15/samtools-1.15.tar.bz2"
  sha256 "35d945a5eee9817a764490870474f24e538400b0397b28f94247a5b91447215d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b13f56d80d0cb7b5667e9ad00bc84ae2dabc3ce01c552170f62e8a09a6049a2b"
    sha256 cellar: :any,                 arm64_big_sur:  "c2c24c83fd486e278baee7c7d710a79f051eb439914b522f3a115d066092ac01"
    sha256 cellar: :any,                 monterey:       "8d820e15f59a9d5ac9daf12f39d11abe74ca0cb3f18e9254d793cb876f427f4c"
    sha256 cellar: :any,                 big_sur:        "b90a516f021c08afb3991d089430a5bf161872abc229e754a308d992e0fce8a1"
    sha256 cellar: :any,                 catalina:       "8fb5952ca93f8fdbfe3ab8ebb45607a1eeb3f7d0161cb44ee3b5814802eaa0f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f32db9c2b4363d30327d56e7969c54f8c78372ee1e96cc0f79591d335b15af2d"
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

class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.18/samtools-1.18.tar.bz2"
  sha256 "d686ffa621023ba61822a2a50b70e85d0b18e79371de5adb07828519d3fc06e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e88fadc80bff54c12b710f151870cf66fa9cdd187ba435b3730e0525c2952a12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c5731abfb7cb80c9fd7ef58cf6b804bbeb4c981f440f9f3356b934e2bf64c14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "480ef4641f0829897b8a0ecb7644bcbe5bf782dbd8ad140bd714deaf85fe70f5"
    sha256 cellar: :any_skip_relocation, ventura:        "9a0d2e9ace4b33dca76dc4e914107e982d54cf73bdcfa4f55254245fd4392a05"
    sha256 cellar: :any_skip_relocation, monterey:       "ab1123980c1f03e0ccec054f7fdaa34d6bd97095e6ddf786b4f7dac484c11171"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba3c701142728fc953c87a7cd7a7999146b962959b59ddaabdd0e75b3678afb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7dd8892054693dd4006fd7fcc1d631507b85615964d50f36ab69d7febd4f457"
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

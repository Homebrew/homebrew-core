class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.16.1/samtools-1.16.1.tar.bz2"
  sha256 "2fa0a25f78594cf23d07c9d32d5060a14f1c5ee14d7b0af7a8a71abc9fdf1d07"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7a69d8838724a151eaff8e8fe14f5f97caf854f5de52d67d3e4fa391380aaec3"
    sha256 cellar: :any,                 arm64_big_sur:  "cc0d0126599d102e81a5c033576c8c1b8d59779b49a61e24a999a618f9e3ca64"
    sha256 cellar: :any,                 monterey:       "d35d8aad87428d47a6926226a5032a0722dba57ccd4e29b6a2614d54f43d00a4"
    sha256 cellar: :any,                 big_sur:        "d819e80d01c567a2209ef9f8dfc70babf6307d312af725d287095474fabd405c"
    sha256 cellar: :any,                 catalina:       "4ce2b9ddf8d768b64be522e2712f7ba1d9387d9ee1d7de7839347065ebd7c7a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6a4f449d97437988b9b99e2e0c76e394550566b7cd6041e55050153943fa592"
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

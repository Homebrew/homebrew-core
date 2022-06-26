class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.15.1/samtools-1.15.1.tar.bz2"
  sha256 "708c525ac76b0532b25f14aadea34a4d11df667bc19bf0a74dae617d80526c6e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b9f51d4124f76ab4c60e34c3de5ae33b84b6d197d6a345f38c893b99051fad30"
    sha256 cellar: :any,                 arm64_big_sur:  "e3a8e9be5a0ee4ec482d7fc7084fcb11bf158a88270a2ff084a483ad63c86eb3"
    sha256 cellar: :any,                 monterey:       "2dc4c1ac57ad21f63671014debb3168bab4c19f095aa2d9488640de25bd53c6c"
    sha256 cellar: :any,                 big_sur:        "8219267aacf02256e108a6226c1d1df9c8f95f74cdaf963b30762549057b4bc6"
    sha256 cellar: :any,                 catalina:       "c67ed9a05eac8cf612a07968b94c5588df323a548e3876442e164fff90133808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d249f1ba01a2aee84699cfe3334f0a3011a6058a12278d80184c48cea8cd1213"
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

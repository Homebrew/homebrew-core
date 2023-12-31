class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.19/samtools-1.19.tar.bz2"
  sha256 "fa6b3b18e20851b6f3cb55afaf3205d02fcb79dae3b849fcf52e8fc10ff08b83"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f7a8cd5057113b89787bb68f6dd37b6ac88cd78934c18e4fd7bff0b2ad20a355"
    sha256 cellar: :any,                 arm64_ventura:  "0dd08e9d8a6c5bf4642c4c1994c9bfa69bee83117535664e187628c153c0151d"
    sha256 cellar: :any,                 arm64_monterey: "9fecc118e11dee133ebe90ddf1ae9ae4cb006d9120e929e5ffcc2e9d65a2bdec"
    sha256 cellar: :any,                 sonoma:         "9a7fb4fae73287db5c95628528e18a0b0aff72bbb796a506371034eda3210aee"
    sha256 cellar: :any,                 ventura:        "313d820f6566c5a3eb64bc1ff45281b600216c23e736aba7f3a14ff4d399d145"
    sha256 cellar: :any,                 monterey:       "3ef96fd41bbc4084bea6217fd674a8ca41bedd81b3ae1cbf28e8e01c81f0ed4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2653d4f163422ddece0dbd2097e8374925b27a011a06cfbebeef1237441bc334"
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

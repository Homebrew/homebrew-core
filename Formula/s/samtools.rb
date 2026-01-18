class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.23/samtools-1.23.tar.bz2"
  sha256 "f228db57d25b724ea26fe55c1c91529f084ef564888865fb190dd87bd04ee74c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a7b121c38e13f45ad221f61f52a21243dddae63c2f80933f01e3fc9e62094452"
    sha256 cellar: :any,                 arm64_sequoia: "7d054f88fc3038fbd0a5c1c43e0d386e6781ffb78ec938f908b850ac37574135"
    sha256 cellar: :any,                 arm64_sonoma:  "7f7e7acea785a7083e4eeffdd322e56d199cc8a6b06d63b62af9722babb19606"
    sha256 cellar: :any,                 sonoma:        "d4151c2b0ff6e00c02c1c6c2e29372005ec0d6bf125d9306704530ba7edbf53c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efc4caf278e7a0fd84e6b54f085037edf3d02cb574092e3893f1b4a92aa1a52e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62e720eba3b3f4f44c3bcefe3ce0343da6eb40412eb54dad9011f2d636d12b44"
  end

  depends_on "htslib"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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

class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.23/samtools-1.23.tar.bz2"
  sha256 "f228db57d25b724ea26fe55c1c91529f084ef564888865fb190dd87bd04ee74c"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "9dace01b0700008a8d7e35976ec194476446b50f04014dfedffadb670e948622"
    sha256 cellar: :any,                 arm64_sequoia: "285ddbc415e9fb2b4a1f2155fa36bfbee269ac2bb6020bb1b5314ef4247fe6c9"
    sha256 cellar: :any,                 arm64_sonoma:  "3738129dfce564701c950ecd2102e0969b27bacb6aa08c0f5604c6c330951334"
    sha256 cellar: :any,                 sonoma:        "95e4b92fac0ea9636086e37185ea9297f8a97924f2ee523ea1c3916ac561ac25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4ece12543cbdba33b6409698a3683f2148d6e35f27a19cda26f06a7a56181d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47c382f55855c466ff8283fbfd4f6f7571de3ae0cf9f1200499feab9d4710397"
  end

  depends_on "htslib"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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

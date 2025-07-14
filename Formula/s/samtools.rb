class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.22/samtools-1.22.tar.bz2"
  sha256 "4911d01720f246cb97855870b410bbe4d2c2fd7fbf823ea0f7daf0f32545819d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "220446fda87460adab2eb115c4544317ac4efbd4fde226b912910500953de9f1"
    sha256 cellar: :any,                 arm64_sonoma:  "2e5e85e52f71cc46f3a13deb0f1846fb878f24aec58f820d92f0ceb7214b6a11"
    sha256 cellar: :any,                 arm64_ventura: "e22d88a95b2c57696e3d044023e8361a88e318815b541303b9306a33fce8c5fc"
    sha256 cellar: :any,                 sonoma:        "ac88a58eed05adb2d30fcaec291456cdcd4ec4389ce6849e010440447279dd3e"
    sha256 cellar: :any,                 ventura:       "585ae2c4165a6eb58e5ae1743fb0b2d0cdac37f0d49ef90ff1dad7a401c0a95b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58b35560dde7b56963008cb3339d6636013058fc456b7bdb2115875675892a01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc61d5a65fc6f459e390a0b39bd2d3cb9b4d0fd8c074d7d0e059cd165d44ade4"
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

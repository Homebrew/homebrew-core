class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.19.2/samtools-1.19.2.tar.bz2"
  sha256 "71f60499668e4c08e7d745fbff24c15cc8a0977abab1acd5d2bb419bdb065e96"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "96d8291bf5b218bcbc87e61885c90d6298f1882075e090f8e34cb94a115cdd68"
    sha256 cellar: :any,                 arm64_ventura:  "a4e4d64adf90122ddd31cae855e59ec285788ea8996ae9855270f7f9e60b4512"
    sha256 cellar: :any,                 arm64_monterey: "d81893a1352ea09353ac3ae0330df7e3b23cb75fa649ce68ebe2f791d7444c20"
    sha256 cellar: :any,                 sonoma:         "141687bd1b2d1379411f26e9054f3122ea04a95101e854fa44f818bba137dc24"
    sha256 cellar: :any,                 ventura:        "f4b0a0160042f68be3861e16cd1d057b821eb4f13f3d37e1754274503d54e08a"
    sha256 cellar: :any,                 monterey:       "80cd66bb44c7db3d91f3719effdd67f4968296f6358095b82b5cbca64c78b9f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdf0ca5b2caf6e9abd2a718478e5cb0a1d5243e4f322db5b392544d90f0cf6f4"
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

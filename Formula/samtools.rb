class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.14/samtools-1.14.tar.bz2"
  sha256 "9341dabaa98b0ea7d60fd47e42af25df43a7d3d64d8e654cdf852974546b7d74"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3810531d7ba40d9292e06eb7a969ae2f30ec439c8254d65858108d35813d013b"
    sha256 cellar: :any,                 arm64_big_sur:  "1b094875a3cd7111cd2d7194acc600ad03ccef038ec9fae76b514f3351b1f9c1"
    sha256 cellar: :any,                 monterey:       "3782db6cc058505537f1722dc8bd98f1406e0f72ccb878dd0d4c61990359252c"
    sha256 cellar: :any,                 big_sur:        "fd80f26de0ab3138062c69451e7ec99d313d3d9f817c61ee975c623813339302"
    sha256 cellar: :any,                 catalina:       "08cde6e2083249a7099026da42111e40ad13cb21f6ae3a1de3048ef78c4e9d81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "213254affeaf2babcfb46d41b873572940ee584468abc291c985a90b31bde3e1"
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

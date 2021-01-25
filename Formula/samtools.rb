class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.11/samtools-1.11.tar.bz2"
  sha256 "e283cebd6c1c49f0cf8a3ca4fa56e1d651496b4d2e42f80ab75991a9ece4e5b6"
  license "MIT"

  bottle do
    cellar :any
    sha256 "11ff7dd1ba8a25ff664073d17f22778ec1d7618c96848bc4ab11d3e160ced6b7" => :big_sur
    sha256 "ddb02ad38d425b294f0128fec8b5f89f030d0570bd9f9e3a40e06ebe415e83ac" => :arm64_big_sur
    sha256 "b078ad37ae8107643fc20e3b2c2a90c229fa80ea087e8f392bb29964bb7b90c6" => :catalina
    sha256 "4dba7c6bba7c28ff151c98d483c2490c39280f9b4108db057d456f602c193a5d" => :mojave
    sha256 "dafc393d7128f14fee13b4ebf27cad545154c9b45cda7341a78b03fa340b699a" => :high_sierra
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

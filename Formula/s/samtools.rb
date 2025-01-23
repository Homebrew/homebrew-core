class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.21/samtools-1.21.tar.bz2"
  sha256 "05724b083a6b6f0305fcae5243a056cc36cf826309c3cb9347a6b89ee3fc5ada"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "0fd24379c43d47525d722a4220c1564bb59fe969eb2161e62aba519e73523c30"
    sha256 cellar: :any,                 arm64_sonoma:   "c7625984593989f64b6872232c65487466ca5f8f8429d64d858316c93ad50381"
    sha256 cellar: :any,                 arm64_ventura:  "b3f4e88d641907504ccb2378c69b6386fd37ae5c82b2344af678e386ca360266"
    sha256 cellar: :any,                 arm64_monterey: "87a313d7110756bd669a18a3090750f9b03269404b9a61a1cf143575defd5dcc"
    sha256 cellar: :any,                 sonoma:         "9b9864f309544aa5aee0e8b6ed0eaae5c0e7c2a3920607aad6afdb7bbc2b6da9"
    sha256 cellar: :any,                 ventura:        "2dd72265adf5a7e652d0f60f4f07bc041f6bfaad7403abe615330807a7168ed7"
    sha256 cellar: :any,                 monterey:       "4c375467980995250fb1a8a9e4b67ac57607a546c478e28363feafe29d009510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b81f8cbedc6b82d62a3fe9ab64e91b5e437e1492927a5ea7172d1f9341ec627"
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

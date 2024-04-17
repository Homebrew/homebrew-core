class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.20/samtools-1.20.tar.bz2"
  sha256 "c71be865e241613c2ca99679c074f1a0daeb55288af577db945bdabe3eb2cf10"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b466cf7f659e4af5fd47b7ffc9805ed8a33d43b44f627a806d7ae2b06349ea9e"
    sha256 cellar: :any,                 arm64_ventura:  "126b0c5c624a6bea08ace22d8604cc4bcd2d6492fe06228ce68dd6956f725520"
    sha256 cellar: :any,                 arm64_monterey: "27bac69761fc5479833af4ca8ebaae31edfb33d9d7512fdb6817aaa6dc344eb4"
    sha256 cellar: :any,                 sonoma:         "9a03773efc98b5003896c242f437940f3bccae054b31c2b28b393a5144175bd7"
    sha256 cellar: :any,                 ventura:        "2bb512594b1b6df69f4dcf06eded206f15ed6ff82ae06761b93b0e5c8fddd27f"
    sha256 cellar: :any,                 monterey:       "c006cb21e1b4934bd58cf76d4f04b905b4ea3fedcdce83d063107a11e105ae8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1390d215456d06f7de7aa10f32d34eedb1dd41d86e47309450e7cca1facb8d2a"
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

class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.22.1/samtools-1.22.1.tar.bz2"
  sha256 "02aa5cd0ba52e06c2080054e059d7d77a885dfe9717c31cd89dfe7a4047eda0e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3cdcec6325a6e395a92451d4cf46c7adfd75567fb791da1b8f080baf876955d4"
    sha256 cellar: :any,                 arm64_sequoia: "4e6374d7b2e82285cd2d94cf69d9456ba1ebacded9b7c54b7b13cfe6d7571dfc"
    sha256 cellar: :any,                 arm64_sonoma:  "5d9c3ff32e78ccff22c04160384cf9f561f8e09e14b5cae07a23c10e030e2e8c"
    sha256 cellar: :any,                 arm64_ventura: "8e75a8f5bb0225069dac4603e771b10849e68b4932240a6870ff0ce9391e4e5e"
    sha256 cellar: :any,                 sonoma:        "1bc8878384afbe3ce9db394963cbc922d1ce5852a81fcaf9331b90acfb4b870d"
    sha256 cellar: :any,                 ventura:       "ee42796a160346080707d18a9c1b92d4b3056faac0f8234fdba437f546d2ab6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd5d5e0c5c2f4eae65695b0944643bf15a65e293897885bd97d74348099e7d5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3008247e5b85f0fc9529d0fdcaaeeb01109b819ad9236e747f1eeb7c3378ac09"
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

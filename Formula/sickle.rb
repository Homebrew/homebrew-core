class Sickle < Formula
  desc "Windowed adaptive trimming for FASTQ files using quality"
  homepage "https://github.com/najoshi/sickle"
  url "https://github.com/najoshi/sickle/archive/v1.33.tar.gz"
  sha256 "eab271d25dc799e2ce67c25626128f8f8ed65e3cd68e799479bba20964624734"

  bottle do
    cellar :any_skip_relocation
    sha256 "3aeaaa4393148876cc55cc9defbe82ae0fe0dabea18e418413b2aa8cff23dd0b" => :high_sierra
    sha256 "844b063d1496d2a7c7f8a12b2239ae32766a538557d44f712c584a30b9775fae" => :sierra
    sha256 "138b38a20aefc55ec4005ee4c4622ec332cbb13ff4ebc39ff45d91a2c12afde8" => :el_capitan
  end

  def install
    system "make"
    bin.install "sickle"
  end

  test do
    (testpath/"test.fastq").write <<~EOS
      @U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
      +
      IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII0000000000
    EOS
    cmd = "#{bin}/sickle se -f test.fastq -t sanger -o /dev/stdout"
    assert_equal "GTGTC", shell_output(cmd).lines[1][-6..-2]
  end
end

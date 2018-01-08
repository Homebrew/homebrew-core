class Sickle < Formula
  desc "Windowed adaptive trimming for FASTQ files using quality"
  homepage "https://github.com/najoshi/sickle"
  url "https://github.com/najoshi/sickle/archive/v1.33.tar.gz"
  sha256 "eab271d25dc799e2ce67c25626128f8f8ed65e3cd68e799479bba20964624734"

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
    assert_match "GTGTC", shell_output(cmd).chomp
  end
end

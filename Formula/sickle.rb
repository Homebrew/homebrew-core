class Sickle < Formula
  desc "Windowed adaptive trimming for FASTQ files using quality"
  homepage "https://github.com/najoshi/sickle"
  url "https://github.com/najoshi/sickle/archive/v1.33.tar.gz"
  sha256 "eab271d25dc799e2ce67c25626128f8f8ed65e3cd68e799479bba20964624734"

  bottle do
    cellar :any_skip_relocation
    sha256 "f33fa7f23d66b928b117a8c3ccfd54a30dc5a798ed6444350be47ced2bebc49e" => :catalina
    sha256 "dc6b4eea0f8da0b1611e12197157c9985c931567d466e3a47f89250a8180b879" => :mojave
    sha256 "3aeaaa4393148876cc55cc9defbe82ae0fe0dabea18e418413b2aa8cff23dd0b" => :high_sierra
    sha256 "844b063d1496d2a7c7f8a12b2239ae32766a538557d44f712c584a30b9775fae" => :sierra
    sha256 "138b38a20aefc55ec4005ee4c4622ec332cbb13ff4ebc39ff45d91a2c12afde8" => :el_capitan
  end

  uses_from_macos "zlib"

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
    assert_equal "GTGTC\n", shell_output(cmd).lines[1][-6..-1]
  end
end

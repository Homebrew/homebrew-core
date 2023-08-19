class Sickle < Formula
  desc "Windowed adaptive trimming for FASTQ files using quality"
  homepage "https://github.com/najoshi/sickle"
  url "https://github.com/najoshi/sickle/archive/v1.33.tar.gz"
  sha256 "eab271d25dc799e2ce67c25626128f8f8ed65e3cd68e799479bba20964624734"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e777fe310603467d2feaa5702bca61f2444c2b2e1e82cd2ba0bc21dfb7a2ccd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "520c9e80b25890a25bb12baca208128352164a31aa7cb76111d9a4a918106c48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26c645faa585ff21ef7eee6c62ac906df4bef93dcceb3647168a7c89bcb7ed48"
    sha256 cellar: :any_skip_relocation, ventura:        "aa3b3a6e43a41be578a83db5967567233ae0958695485dba360ca79343b2e110"
    sha256 cellar: :any_skip_relocation, monterey:       "015b2cdfc919a31988a727c52852cef682f9ea2de7826f8e90b346071d32330c"
    sha256 cellar: :any_skip_relocation, big_sur:        "49cf432d5190d21d61d741d5d10c44e42d0fe5e40222f8af9dec1b35ff916029"
    sha256 cellar: :any_skip_relocation, catalina:       "f33fa7f23d66b928b117a8c3ccfd54a30dc5a798ed6444350be47ced2bebc49e"
    sha256 cellar: :any_skip_relocation, mojave:         "dc6b4eea0f8da0b1611e12197157c9985c931567d466e3a47f89250a8180b879"
    sha256 cellar: :any_skip_relocation, high_sierra:    "3aeaaa4393148876cc55cc9defbe82ae0fe0dabea18e418413b2aa8cff23dd0b"
    sha256 cellar: :any_skip_relocation, sierra:         "844b063d1496d2a7c7f8a12b2239ae32766a538557d44f712c584a30b9775fae"
    sha256 cellar: :any_skip_relocation, el_capitan:     "138b38a20aefc55ec4005ee4c4622ec332cbb13ff4ebc39ff45d91a2c12afde8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d084fefaf95e4433a64685c9c332964389911bbbdbb038aeeb87c2d16f06f2ab"
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
    assert_equal "GTGTC\n", shell_output(cmd).lines[1][-6..]
  end
end

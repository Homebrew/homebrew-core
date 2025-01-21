class Seqtk < Formula
  desc "Toolkit for processing sequences in FASTA/Q formats"
  homepage "https://github.com/lh3/seqtk"
  url "https://github.com/lh3/seqtk/archive/refs/tags/v1.4.tar.gz"
  sha256 "d124604ec24f29ed14ce127426ab90e0f3a2c0280c80d1a3ff8b1c09feede19c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f144c4cd7e4b7fa0e8cb87924587294a4dc0e04464584894455bc3221b9c2c2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd2129e3b101791a70e29bfed5e63800779881c4d6cbefc06a53e9008cf9e919"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10eca0327229b13765451786c03c7def8fd277d014f5a74e709915fc50a8fdbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb2ec54def8fadafa1c673e851180f0883e651582a78397394706602786d3559"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "325cb00b4694492303da6d2b776bf7ecfc31f9ac6259a9d3d0a1b9ada86d29cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed20188611155d148d1198516c9ddbdf0e79f518e436421a0a9599a2d5c6329e"
    sha256 cellar: :any_skip_relocation, ventura:        "a22a8a2d9b1568d03efe732ccd3a4fa461f0b8adab78587a8b6fdbfbb8db292a"
    sha256 cellar: :any_skip_relocation, monterey:       "fed18e5929988555d1623c2a023821de35cd3f200adb40bbb56ecd56b48b5646"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac4bce32281d7b1c988285d0341691bacfaeba03a6d9d82113ff0ead8125accb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afd0ca56a9c7ed70b7958688d5d38c85b48c18eba76a52f303abad25f7b41eb0"
  end

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "seqtk"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCT
      CTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    assert_match "TCTCTG", shell_output("#{bin}/seqtk seq test.fasta")
  end
end

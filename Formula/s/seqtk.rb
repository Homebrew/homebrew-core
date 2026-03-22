class Seqtk < Formula
  desc "Toolkit for processing sequences in FASTA/Q formats"
  homepage "https://github.com/lh3/seqtk"
  url "https://github.com/lh3/seqtk/archive/refs/tags/v1.5.tar.gz"
  sha256 "384aa1e3cecf4f70403839d586cbb29d469b7c6f773a64bc5af48a6e4b8220a6"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c3982f3b57602403755867dd064d61c6f02f091100b46eb415b1899ad133a95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2eca65fdd2de251a51446543a85d9525a2b37e5d97a4971403526c7559fef3c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adcff964ff3a23159f6ff353bc41be823f695532d8f198da8a51375509106522"
    sha256 cellar: :any_skip_relocation, sonoma:        "10001de19a08b1f96495e316d8654e245ce6ed56cd6a4c4dacc3b0cacb486fc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ae523d2e84ab2cd7d9bbdfc0ffa5244b53ff80776575b11d675e9025b76ee96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8996464a2266a07bb97db6a6a69b5376c40dfb4476c4d2413aed6f840a59705"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

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

class Seqtk < Formula
  desc "Toolkit for processing sequences in FASTA/Q formats"
  homepage "https://github.com/lh3/seqtk"
  url "https://github.com/lh3/seqtk/archive/refs/tags/v1.5.tar.gz"
  sha256 "384aa1e3cecf4f70403839d586cbb29d469b7c6f773a64bc5af48a6e4b8220a6"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cef0b305702d591dba9d4cdf9d56354a0a0899adcef89a6ce21f58cb04d8c586"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "792b2f9c97b31099358e00f85d5f087d56c6d7b10dcd1d1a6de5c3c28fa90576"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cc03676c5257015029aaa5d4db31a473574c14e9c6dc1d451a27a91d6700bd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "edf244951a989be8cd04da63e9d3a4089b933cdd826ab15c903749ddea2b23ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ae2d0b91c70d30f81651c6572c867e109ba6b628b58932377b99f9c3c46b062"
    sha256 cellar: :any_skip_relocation, ventura:       "4d79bd6387346078f950c2a849f5857c0e3cc43cd1ff01fc278ea1a16a8474d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30fb0030644e299f3f71ea7ec61be7c9cf72a7dcd70331efe7299dfae6296a02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4eea62b0b0acfeb50dd08cd385e8b486f223b255430ff57d1c3242a7fd564e5"
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

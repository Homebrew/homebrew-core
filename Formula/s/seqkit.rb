class Seqkit < Formula
  desc "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation in Golang"
  homepage "https://bioinf.shenwei.me/seqkit"
  url "https://github.com/shenwei356/seqkit/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "76d105921f918be20e616fbb607fe0fb2db603535a254ec0f853cb36bef817da"
  license "MIT"
  head "https://github.com/shenwei356/seqkit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fafcd5531a29dd73b5870d0c9525c0a9f6bcf77967d750e4bb62bc9a18ebf3b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fafcd5531a29dd73b5870d0c9525c0a9f6bcf77967d750e4bb62bc9a18ebf3b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fafcd5531a29dd73b5870d0c9525c0a9f6bcf77967d750e4bb62bc9a18ebf3b5"
    sha256 cellar: :any_skip_relocation, ventura:        "bb9b4b600fe138d1544f3ed9e9024e6b53f5d47d7fc868a8ece96f0a3c74430f"
    sha256 cellar: :any_skip_relocation, monterey:       "bb9b4b600fe138d1544f3ed9e9024e6b53f5d47d7fc868a8ece96f0a3c74430f"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb9b4b600fe138d1544f3ed9e9024e6b53f5d47d7fc868a8ece96f0a3c74430f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b84099abd1282a294988c4f94180188c98e43d3462c62e84dbfceb5537d50777"
  end

  depends_on "go" => :build

  resource "homebrew-testdata" do
    url "https://raw.githubusercontent.com/shenwei356/seqkit/e37d70a7e0ca0e53d6dbd576bd70decac32aba64/tests/seqs4amplicon.fa"
    sha256 "b0f09da63e3c677cc698d5cdff60e2d246368263c22385937169a9a4c321178a"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./seqkit"
  end

  test do
    resource("homebrew-testdata").stage do
      assert_equal ">seq1\nCCCACTGAAA",
      shell_output("#{bin}/seqkit amplicon --quiet -F CCC -R TTT seqs4amplicon.fa").strip
    end
  end
end

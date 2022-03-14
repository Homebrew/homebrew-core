class Seqkit < Formula
  desc "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation in Golang"
  homepage "https://bioinf.shenwei.me/seqkit"
  url "https://github.com/shenwei356/seqkit/archive/v2.2.0.tar.gz"
  sha256 "6e7e292532d78d54ac7aecb934f992c85d04b2dcb2d7a1141808bada0f5b13ba"
  license "MIT"
  head "https://github.com/shenwei356/seqkit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c643716399f6ed26416ce5874b1799b39b5372786f0f9e8ab8c83e603afd433"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5317234e738eb747463b979490c089c4b076fe573556d08ae7df6141982c6b9"
    sha256 cellar: :any_skip_relocation, monterey:       "57086e68433c69dacbaa152d5c9487ca7848a5932f1781afd1fad56e531ac342"
    sha256 cellar: :any_skip_relocation, big_sur:        "16ca0d4eef7fe48661fd2ca9ed30701bac60edcad05643436378e90bee7400c6"
    sha256 cellar: :any_skip_relocation, catalina:       "5935966181252b37b6bf80d97bd2e43651f51841fd74c76819f643eba08520b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cd0f87b8741865657d2bcad503e2b89ab3eba053457f02e5169261db531b233"
  end

  depends_on "go" => :build

  resource "testdata" do
    url "https://raw.githubusercontent.com/shenwei356/seqkit/e37d70a7e0ca0e53d6dbd576bd70decac32aba64/tests/seqs4amplicon.fa"
    sha256 "b0f09da63e3c677cc698d5cdff60e2d246368263c22385937169a9a4c321178a"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./seqkit"
  end

  test do
    resource("testdata").stage do
      assert_equal ">seq1\nCCCACTGAAA",
      shell_output("#{bin}/seqkit amplicon --quiet -F CCC -R TTT seqs4amplicon.fa").strip
    end
  end
end

class Seqkit < Formula
  desc "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation in Golang"
  homepage "https://bioinf.shenwei.me/seqkit"
  url "https://github.com/shenwei356/seqkit/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "43fe3ed16382ff3cb702fe0d724f8d9ce604be4a635106fdc7bd0c3c307bdd75"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3f896c3de25e93c1541ec343e9e23bc818cf6163790c824394f2cde4f5a282b6"
    sha256 cellar: :any_skip_relocation, big_sur:       "35b79c707358f78714916c36474368626d9c901fa1a407dfa8b7409b13f81071"
    sha256 cellar: :any_skip_relocation, catalina:      "4b28207b5efa495071f8f742034e8513e2157eb8f5609980b8d7aab814c51bcf"
    sha256 cellar: :any_skip_relocation, mojave:        "a34925843299ca13e59b4a7a8ffed78ab0a6e326b3448d1a0096d68cabd88ae5"
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

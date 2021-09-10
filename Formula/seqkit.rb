class Seqkit < Formula
  desc "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation in Golang"
  homepage "https://bioinf.shenwei.me/seqkit"
  url "https://github.com/shenwei356/seqkit/archive/v2.0.0.tar.gz"
  sha256 "5e6be45885300ad53d040136241c3af1fd67ce2e9ef96723751863de57eb1b2c"
  license "MIT"
  head "https://github.com/shenwei356/seqkit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4088640abc8d7645b93c6e5291a784f9d5c802075bcf713503132e8508e5a7f5"
    sha256 cellar: :any_skip_relocation, big_sur:       "6fc5ec20de4ab5a736afb4a16c0007703b8b42e1d419d6d722dbf74a84d2c7e0"
    sha256 cellar: :any_skip_relocation, catalina:      "a49c9389258ee8a151466f4df018e69f81497b73ef199edde0a012d517ca3059"
    sha256 cellar: :any_skip_relocation, mojave:        "0ec54399d6f18b4b3c8d5317caa1b4358f226b778cbceff86a25cbc337a1fd52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "968b6e599fc18bb2cf3a88d0723b94c5c858c2c79fa7409d0c1447b2e47732fb"
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

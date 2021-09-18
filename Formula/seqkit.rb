class Seqkit < Formula
  desc "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation in Golang"
  homepage "https://bioinf.shenwei.me/seqkit"
  url "https://github.com/shenwei356/seqkit/archive/v2.0.1.tar.gz"
  sha256 "b4c36516840ec71e5c2fc90587d3fa5efc284bbc1026f2851c991ee9377e17c3"
  license "MIT"
  head "https://github.com/shenwei356/seqkit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ba153360728957ba08599f553fc7c35d4c137228047596b557ca3e3e41c6f748"
    sha256 cellar: :any_skip_relocation, big_sur:       "8c6cc9a3261800c70dd843064d56d3cf1e9cbdceedcdb80daea8c82dc194c777"
    sha256 cellar: :any_skip_relocation, catalina:      "189de82640a5730d0f7ef36d6a482cd6ff001ade3c1743993e74c18d622bac43"
    sha256 cellar: :any_skip_relocation, mojave:        "cb007a069c9b234d70ce37aebae4ac97c18b24827bb9435849ccb86d284f6ac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb23238cb3414c2dabef0b05d7aa4ab3dc4fc92c5d2defa39d648660a0be4f64"
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

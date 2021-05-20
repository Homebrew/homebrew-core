class Seqkit < Formula
  desc "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation in Golang"
  homepage "https://bioinf.shenwei.me/seqkit"
  url "https://github.com/shenwei356/seqkit/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "43fe3ed16382ff3cb702fe0d724f8d9ce604be4a635106fdc7bd0c3c307bdd75"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "877cc15c035bd31a8559654ec06971f392214f37c5d90cea51363fb8c7d1499e"
    sha256 cellar: :any_skip_relocation, big_sur:       "bdfd5c531124c243c1657e59544aafc945298f1d34eabbb2b47568d921db9d9f"
    sha256 cellar: :any_skip_relocation, catalina:      "eb38fcc7dd50615069a6f0ee5e803c28a4adc3985ac77aa8b03f1a575ba028d0"
    sha256 cellar: :any_skip_relocation, mojave:        "d4b73500720c0e829cf8183417ecddff80f858ebaa6b6792aff4ea52e9da7cca"
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

class Seqkit < Formula
  desc "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation in Golang"
  homepage "https://bioinf.shenwei.me/seqkit"
  url "https://github.com/shenwei356/seqkit/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "260ff3d483965b15071f4632f9f9c35ca335ebebbd74aa3322ecc37a999be7fe"
  license "MIT"
  head "https://github.com/shenwei356/seqkit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e57c507876b8904f066909d3d3e733c22db522698408d11ece06bf34564156a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cb5765855a07dce5b551f9939481e5fa4b29fb91b2ef53843c35dad6434f555"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d72afab3afbd04f58647c3c20d0e2a96b82fe5ddd2715984242467b72e86a02"
    sha256 cellar: :any_skip_relocation, sonoma:         "124c29527f79c53260f8ca7337d673ff89ecce7c82149d0367ee95aaa09e3df6"
    sha256 cellar: :any_skip_relocation, ventura:        "2c3225241e0556804faea50b8d1721f2a587ed98e22feb81d121729248b18e66"
    sha256 cellar: :any_skip_relocation, monterey:       "d874a2e94ccee427d803563543cb46bf0f55ea29442d0c336ae3f0ed65e16d5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a50ea0f58e3820372221637e0fe7a09c5d93ccfe1b5632359694092a0493ab9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./seqkit"
  end

  test do
    resource "homebrew-testdata" do
      url "https://raw.githubusercontent.com/shenwei356/seqkit/e37d70a7e0ca0e53d6dbd576bd70decac32aba64/tests/seqs4amplicon.fa"
      sha256 "b0f09da63e3c677cc698d5cdff60e2d246368263c22385937169a9a4c321178a"
    end

    resource("homebrew-testdata").stage do
      assert_equal ">seq1\nCCCACTGAAA",
      shell_output("#{bin}/seqkit amplicon --quiet -F CCC -R TTT seqs4amplicon.fa").strip
    end
  end
end

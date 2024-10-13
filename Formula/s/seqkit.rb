class Seqkit < Formula
  desc "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation in Golang"
  homepage "https://bioinf.shenwei.me/seqkit"
  url "https://github.com/shenwei356/seqkit/archive/refs/tags/v2.8.2.tar.gz"
  sha256 "9cf1e744b785fa673af5a7a1ce2f96d52dc03e14b6537097df86aa6266204556"
  license "MIT"
  head "https://github.com/shenwei356/seqkit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ae5bd57f2e7234d3184b7b2556f56e4f1c6145c65748466a67e42a13d909b7fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9dcd42289ac72832bc85b38014c72c13fafe5cfb50317d885b4d2745464d334c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66a9d98aa8840def1fb316a3ca8af83ee1f71a0e4a3ee33bd7305f5bf1b12e94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6f0882a80be6844b77e291f340fb511474895c3a95ef47acb524de7de76721d"
    sha256 cellar: :any_skip_relocation, sonoma:         "489e57fc9953e5106d6153555242bd5fea72ed0d7ce27aed9064adb4fe9a74db"
    sha256 cellar: :any_skip_relocation, ventura:        "31c711579f918775b966539136743c45033721f6a248bc2508bfa445c2f335f4"
    sha256 cellar: :any_skip_relocation, monterey:       "b0a5ee68f3a03d3b1d6de6d9e866e4bd9763ae99cd350470e8d792f1986c0730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdc366167644519084ff23ef08929101e17e4ac03773a36b1744be53334dc854"
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

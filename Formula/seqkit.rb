class Seqkit < Formula
  desc "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation in Golang"
  homepage "https://bioinf.shenwei.me/seqkit"
  url "https://github.com/shenwei356/seqkit/archive/v2.4.0.tar.gz"
  sha256 "c319f3d5feb7c99309e654042432959f01bbc5f7e4c71f55dc9854df46c73c7f"
  license "MIT"
  head "https://github.com/shenwei356/seqkit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38404f14993d1fdfecdb0396975c7e2543878ed3a023a3ef3d1b9ba454b1ab5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38404f14993d1fdfecdb0396975c7e2543878ed3a023a3ef3d1b9ba454b1ab5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38404f14993d1fdfecdb0396975c7e2543878ed3a023a3ef3d1b9ba454b1ab5f"
    sha256 cellar: :any_skip_relocation, ventura:        "ab59d265baf201dfe399d255658ca131f79ba58e19c6cc16beb78f7196bdccd8"
    sha256 cellar: :any_skip_relocation, monterey:       "ab59d265baf201dfe399d255658ca131f79ba58e19c6cc16beb78f7196bdccd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab59d265baf201dfe399d255658ca131f79ba58e19c6cc16beb78f7196bdccd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35c3383ed1d88a4b4f48b874833c09f67622d00449554a650e31fc99874116ed"
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

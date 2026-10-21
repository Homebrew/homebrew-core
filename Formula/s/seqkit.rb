class Seqkit < Formula
  desc "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation in Golang"
  homepage "https://bioinf.shenwei.me/seqkit"
  url "https://github.com/shenwei356/seqkit/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "7df95904ce438c1a1a7b1fc06f20479a169e69209ac59abae8e80c60a1e65d60"
  license "MIT"
  head "https://github.com/shenwei356/seqkit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "761d0952bff55f68df26a8137bf23e713d55a6068c7d3c241a5cf618b445dd0b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "761d0952bff55f68df26a8137bf23e713d55a6068c7d3c241a5cf618b445dd0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "761d0952bff55f68df26a8137bf23e713d55a6068c7d3c241a5cf618b445dd0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cc07ee5d9c53a1ae5ec93ced9d47e32f02321261a01e5b0fa82230e7687af32e"
    sha256 cellar: :any,                 x86_64_linux:      "db1685f908a4639df6da238e9b5718ad408291e1d3c3469e5e0ce285bacef63a"
  end

  depends_on "go" => :build

  resource "homebrew-testdata", :test do
    url "https://raw.githubusercontent.com/shenwei356/seqkit/e37d70a7e0ca0e53d6dbd576bd70decac32aba64/tests/seqs4amplicon.fa"
    sha256 "b0f09da63e3c677cc698d5cdff60e2d246368263c22385937169a9a4c321178a"
  end

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./seqkit"

    # generate_completions_from_executable(bin/"seqkit", "genautocomplete", "--shell")
    # We do this because the command to generate completions doesn't print them
    # to stdout and only writes them to a file
    system bin/"seqkit", "genautocomplete", "--shell", "bash", "--file", "seqkit.bash"
    system bin/"seqkit", "genautocomplete", "--shell", "zsh", "--file", "_seqkit"
    system bin/"seqkit", "genautocomplete", "--shell", "fish", "--file", "seqkit.fish"
    bash_completion.install "seqkit.bash" => "seqkit"
    zsh_completion.install "_seqkit"
    fish_completion.install "seqkit.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/seqkit version")

    resource("homebrew-testdata").stage do
      assert_equal ">seq1\nCCCACTGAAA",
      shell_output("#{bin}/seqkit amplicon --quiet -F CCC -R TTT seqs4amplicon.fa").strip
    end
  end
end

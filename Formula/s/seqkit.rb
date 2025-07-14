class Seqkit < Formula
  desc "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation in Golang"
  homepage "https://bioinf.shenwei.me/seqkit"
  url "https://github.com/shenwei356/seqkit/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "5ebb8bd72b52a0b17064c7afda54a784bd71940fa28ca03114334af550734437"
  license "MIT"
  head "https://github.com/shenwei356/seqkit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "918a0fa59ec75b0f5f76918d70fa147f929ca8959573b83ec116a3123184a406"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "918a0fa59ec75b0f5f76918d70fa147f929ca8959573b83ec116a3123184a406"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "918a0fa59ec75b0f5f76918d70fa147f929ca8959573b83ec116a3123184a406"
    sha256 cellar: :any_skip_relocation, sonoma:        "22f30917da5615b3f64ac7c0d29874c9b8006f208d3b63b91b4ea749449243a6"
    sha256 cellar: :any_skip_relocation, ventura:       "22f30917da5615b3f64ac7c0d29874c9b8006f208d3b63b91b4ea749449243a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e293d78a5891feca493016befebfe691d91b142bc96af153cccceb13b246bc6e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./seqkit"

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

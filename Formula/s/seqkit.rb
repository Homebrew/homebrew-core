class Seqkit < Formula
  desc "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation in Golang"
  homepage "https://bioinf.shenwei.me/seqkit"
  url "https://github.com/shenwei356/seqkit/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "55405cc338962f770279d718c1dabec293a51dde4989c0c2590da3c303105471"
  license "MIT"
  head "https://github.com/shenwei356/seqkit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83997ac9d9a00ba0737ee1818844cc34198e68ca9944dd9e6018c0f57d96993e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83997ac9d9a00ba0737ee1818844cc34198e68ca9944dd9e6018c0f57d96993e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83997ac9d9a00ba0737ee1818844cc34198e68ca9944dd9e6018c0f57d96993e"
    sha256 cellar: :any_skip_relocation, sonoma:        "95d0709017262c3e669769d2c9a6d9544a4b4b983d66976b250beb9cddc69c83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "157a463c1adf24e9f7bbf104b9da79672cac9524a97e64056af8c1abfe0e7e92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bded6403f96e1a85ce904d78ee0c75d5cac6bbf370f32f621c09d7e672b588d0"
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

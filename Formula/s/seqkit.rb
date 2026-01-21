class Seqkit < Formula
  desc "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation in Golang"
  homepage "https://bioinf.shenwei.me/seqkit"
  url "https://github.com/shenwei356/seqkit/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "b8e44f4b2897d2991fbf23c3508a559735a3a6f2f742829648cc66f5a57c9d9c"
  license "MIT"
  head "https://github.com/shenwei356/seqkit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aec1a90607cebdb8034d940285e75d5bb483b2eb3e8e9b122b11672b06f57177"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aec1a90607cebdb8034d940285e75d5bb483b2eb3e8e9b122b11672b06f57177"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aec1a90607cebdb8034d940285e75d5bb483b2eb3e8e9b122b11672b06f57177"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bbb0acf3a4abc393ee555dfa989d664168b60209238d341e70b5203c192a23f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d11a3b2d9e6527324422d73c03d09be004747b28dd368bc032d59f41e89d254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5eaf10eb79e0620ea82a8e8f25f54bd278482c5acec637b6d297414905ab5d55"
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

class Seqkit < Formula
  desc "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation in Golang"
  homepage "https://bioinf.shenwei.me/seqkit"
  url "https://github.com/shenwei356/seqkit/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "e3897f9ccd9503d10c1a8d67d9790ee3e4c91da369e14b716ea7c4e8adba55ee"
  license "MIT"
  head "https://github.com/shenwei356/seqkit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75b5b76e09b39ecebe4e91a8b4e4bdae84fabd95675effa184148047212118ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8cfb637b8f41b6c5bce9c7c91308d8ad1288a71cdfda62e0e134741ced3cc5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8cfb637b8f41b6c5bce9c7c91308d8ad1288a71cdfda62e0e134741ced3cc5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8cfb637b8f41b6c5bce9c7c91308d8ad1288a71cdfda62e0e134741ced3cc5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f22207684037c12254d0be88a2a1f0d0a372fe2d8bd9d8c1e66509e150d5dc3"
    sha256 cellar: :any_skip_relocation, ventura:       "0f22207684037c12254d0be88a2a1f0d0a372fe2d8bd9d8c1e66509e150d5dc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffc8a498f2d0bc0e44a36cc1f791d4b9ae542347e3eeeb77d222c775f6045644"
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

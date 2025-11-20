class Seqkit < Formula
  desc "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation in Golang"
  homepage "https://bioinf.shenwei.me/seqkit"
  url "https://github.com/shenwei356/seqkit/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "2cdb4a71179e7ff9b53cda172300f162cea492e79354eeaf7669cc7758c54f04"
  license "MIT"
  head "https://github.com/shenwei356/seqkit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da2b5fedfbee393966f4f7753a2e4ed871412c1e2416c1976a982bfcb4829b83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da2b5fedfbee393966f4f7753a2e4ed871412c1e2416c1976a982bfcb4829b83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da2b5fedfbee393966f4f7753a2e4ed871412c1e2416c1976a982bfcb4829b83"
    sha256 cellar: :any_skip_relocation, sonoma:        "e194242b616d9d914ff8794d4024bbf5e54689cf3274b3cef915a28803395688"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38a4e7c44251cf145f8929d1c2e94443bde7fd809ef3e91f212e5f97faf00fd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4683c2a72e1c21f513913c757a5990d25dcd4e797eee569a0e0395aa59efe3f8"
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

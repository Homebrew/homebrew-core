class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.27.2.tar.gz"
  sha256 "7df68d38bd93804fe13dc61629453b6ef4f82d55287cd0d635efc41ff99cb5f5"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc3f4f4cd580cf019772b9061345e2a027325c0df4320900631bc524ff4ffd8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce005605856e49613afd260bf708d3f6a0054a0dd335c3206b582c980d051504"
    sha256 cellar: :any_skip_relocation, monterey:       "fd500641724a042b9415f0502d9a82362b655848e4689843a1d3db378faeafbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1be880687f8ef0739e56a4e9f84c786ebd515069c2dbd68af8651e2fdda0728"
    sha256 cellar: :any_skip_relocation, catalina:       "3a44af66bcc48ea6f6fcf643b0c3d85e3ab30591a4726fd1e2bd07a89e60125a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae27863751f4a40d639619976484ef5f824412216ef1291b611c7b4e3bb828a7"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Install shell completions
    (bash_completion/"yq").write Utils.safe_popen_read(bin/"yq", "shell-completion", "bash")
    (zsh_completion/"_yq").write Utils.safe_popen_read(bin/"yq", "shell-completion", "zsh")
    (fish_completion/"yq.fish").write Utils.safe_popen_read(bin/"yq", "shell-completion", "fish")

    # Install man pages
    system "./scripts/generate-man-page-md.sh"
    system "./scripts/generate-man-page.sh"
    man1.install "yq.1"
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq eval --null-input --no-colors '.key = \"cat\"'").chomp
    assert_equal "cat", pipe_output("#{bin}/yq eval \".key\" -", "key: cat", 0).chomp
  end
end

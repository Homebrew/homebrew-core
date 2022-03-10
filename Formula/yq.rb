class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.22.1.tar.gz"
  sha256 "79b4f01774849323db7cc649a270ac4aaccacea2e97260b25f51a634670ecb6e"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "daa39f749aca37b1794fd7cf59e754fdb2b6b5ff076b4bb92f15b47681c2baa9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11f1cdb24787e90ef94f1a16c66d670e16e02ce8282dee72b38d909ab8261a06"
    sha256 cellar: :any_skip_relocation, monterey:       "9d3bccd2fab0e4eb2e4dbfe112fe31335f5e249da485fb1bd05487ae1b9390c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bbe769ca7faf826a7ac1ad7bb4fbfdd4c7532ee86510f6cc5cb995783a5f2f2"
    sha256 cellar: :any_skip_relocation, catalina:       "faaf3a10e31af69b8b956dff0d7b0e2176e023aa6663f14f4f22b24dd5edd080"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efb165f8cdc9e0e95be3a674a9502378bfce005f89c2494d45a91c6dd1e5a68f"
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

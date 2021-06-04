class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.9.3.tar.gz"
  sha256 "b66b9b4182f8fd23d974c3d35e0552f5fdd5280162cec31102f69c3119ed1694"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6b14e64f296af5d9f843f74097aaa311d660867f9329437455b92ed9d619b5b9"
    sha256 cellar: :any_skip_relocation, big_sur:       "a6b66b55f186a043993e5a72ba40f1d8e176ff9c9b1a74ea3c607f02d8fdf7db"
    sha256 cellar: :any_skip_relocation, catalina:      "1bbcf6467cb929a64116c1acb46b06f5101cc3324990a5e599db71661b1b789a"
    sha256 cellar: :any_skip_relocation, mojave:        "ecfd9e4757eb47590154c21cb00ec23df456cdeab77c84c7dfda0db0824f991a"
  end

  depends_on "go" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    system "go", "build", "-ldflags", "-s -w", *std_go_args

    (bash_completion/"yq").write Utils.safe_popen_read("#{bin}/yq", "shell-completion", "bash")
    (zsh_completion/"_yq").write Utils.safe_popen_read("#{bin}/yq", "shell-completion", "zsh")
    (fish_completion/"yq.fish").write Utils.safe_popen_read("#{bin}/yq", "shell-completion", "fish")
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq eval --null-input --no-colors '.key = \"cat\"'").chomp
    assert_equal "cat", pipe_output("#{bin}/yq eval \".key\" -", "key: cat", 0).chomp
  end
end

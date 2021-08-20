class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.12.0.tar.gz"
  sha256 "6de20ab91dbec759627cd3db312c6739f7e4a177d989a5093ef8548e88d605bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4b4757e886317fa37412bca703684e9261e856fae80663afd33c7b24cccccfb7"
    sha256 cellar: :any_skip_relocation, big_sur:       "962eeeec599d9b927175a340f5f44f69b99252821d81eea5b21a8f242e78ddcd"
    sha256 cellar: :any_skip_relocation, catalina:      "ca932b4f1e6db48defe4c8f64b0dec81fb7b2b93e2094e2d5edf6f43e3d4f63f"
    sha256 cellar: :any_skip_relocation, mojave:        "62354827293ebd181991dab146257e8f0fc8a35fc2fe1c47e2e2435f960b7e3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "486809ad753c3c1dfb41c5143a17e830049b237b1733f64724d66597680db8af"
  end

  depends_on "go" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    (bash_completion/"yq").write Utils.safe_popen_read("#{bin}/yq", "shell-completion", "bash")
    (zsh_completion/"_yq").write Utils.safe_popen_read("#{bin}/yq", "shell-completion", "zsh")
    (fish_completion/"yq.fish").write Utils.safe_popen_read("#{bin}/yq", "shell-completion", "fish")
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq eval --null-input --no-colors '.key = \"cat\"'").chomp
    assert_equal "cat", pipe_output("#{bin}/yq eval \".key\" -", "key: cat", 0).chomp
  end
end

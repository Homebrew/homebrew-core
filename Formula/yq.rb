class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.9.6.tar.gz"
  sha256 "40f549d801826b4a7bdad0b2a924f10b354da1d518759b2974e82dda7563f7ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7900b1fb772ebb9af21306ffac209c6764995324ded7b78d57f6fc16d05809f3"
    sha256 cellar: :any_skip_relocation, big_sur:       "94224123e843aebc4f9d02ed7af7a26042b1fbc79a38c0f8f94bc138f8951780"
    sha256 cellar: :any_skip_relocation, catalina:      "ab3a432d0f6313a8f958d85b542b0eed8f5ff5f9696b4c139b05d0bad7a4e044"
    sha256 cellar: :any_skip_relocation, mojave:        "295f9e1ef150408f4a55a76408de192e14e5711146b0d12a66cc55875f212dd0"
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

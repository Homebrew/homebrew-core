class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.6.0.tar.gz"
  sha256 "67c2c4d832da46e3f2d2f364f8b85af5468c9dc1800d5cf066bd25ff5beb9a66"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "97f1817be7288d189905bfd4aded152e84c5bcc25f5b74759c69431d5e0bfb54"
    sha256 cellar: :any_skip_relocation, big_sur:       "c051ab104401da94bd1ee5e73ccbedc944ebce902c0bf953b1df5058d53a7262"
    sha256 cellar: :any_skip_relocation, catalina:      "98ad09e3ac0bee6bdf4d92204726bf072aa5fc0044c843dcb17c9d6b08aa9bbb"
    sha256 cellar: :any_skip_relocation, mojave:        "f8cd451194bb7e8bb690441c138e2c442abf79cd522bbd804d50927885b4aff3"
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

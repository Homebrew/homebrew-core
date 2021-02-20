class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.6.0.tar.gz"
  sha256 "67c2c4d832da46e3f2d2f364f8b85af5468c9dc1800d5cf066bd25ff5beb9a66"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "61c99989b2bdf5e79e4d084b65e5a92344cdc1fc5fd3553926ef0b06bfe95208"
    sha256 cellar: :any_skip_relocation, big_sur:       "5d0fcbadf2fdfc710372879f81b6a3ce7a6d7bd09f5b484720dca6e71c1ce2aa"
    sha256 cellar: :any_skip_relocation, catalina:      "e1d958af2aa57c6395cdba7d42cc976e1db52f960ba8560db680d8d9a81159b2"
    sha256 cellar: :any_skip_relocation, mojave:        "cdd26c23786a0599602fc66bc640e71d60f296d2903708ec6a66bcc8b90c31cf"
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

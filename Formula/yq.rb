class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.7.0.tar.gz"
  sha256 "d4984f8f8ac5151797c8cf9c6ab8b705958802721c4405ef8a99206dcd00dcb5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "537d41f308288e5534bdf9dd6f338e697dfd0c26269a6f4d1b79e6595dc9c977"
    sha256 cellar: :any_skip_relocation, big_sur:       "3fb80f419b64c09b4c6aa7978551bdeaec6bb35f762d48803dadc3bd11564cd3"
    sha256 cellar: :any_skip_relocation, catalina:      "65589802caab855197875d4d9c45d5e1589bbb43c596e2961c2b8e5d8d9334ca"
    sha256 cellar: :any_skip_relocation, mojave:        "119fc499558d21cf55a6efe09296a4024d64769a64c4400066fd9c38059cf937"
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

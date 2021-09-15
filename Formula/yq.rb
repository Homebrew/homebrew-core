class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.12.2.tar.gz"
  sha256 "3a2d0a37fe0b447f585de6a3f59ac3aa85a27b722003cacb1d14e301fb373227"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2528326bef902fc984947fd203e97e74ea706fef4686b24cc5d110b77b39d92a"
    sha256 cellar: :any_skip_relocation, big_sur:       "aa4766853dbdd0a071aa753951f3c123ed3151592571802fbb8bbe14b7bd806d"
    sha256 cellar: :any_skip_relocation, catalina:      "a9c4599b626d3aeb50f7633d90c91a813da58b60503e03cb16f6e347b85b8097"
    sha256 cellar: :any_skip_relocation, mojave:        "2baead72ab2496547e52eec05c8db2a548fd58f5c72923b3665215074dc320b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa744f8682720c9883bd548f0efce2568c4f4ce36c64c22695d95fb029e3162b"
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

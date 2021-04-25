class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.7.1.tar.gz"
  sha256 "19a7c43aaac678065f436ddfdf8b0a75dd3883984f4b9548cabdf53eb09932f9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7c9002c49eedbf653b5d78bddd9c572f41f5e6754d02902a42cdd9764617afda"
    sha256 cellar: :any_skip_relocation, big_sur:       "a216cf0ef5e58c3da870a30da90d7253b1b7eb8ae77ebeef734fcb4be4fde8a9"
    sha256 cellar: :any_skip_relocation, catalina:      "50ee9266dce3db9fa929d194b2057d3f481108bbb6c0cee12c29cd3fdfffaade"
    sha256 cellar: :any_skip_relocation, mojave:        "fc07b88a3c60cebb468ca7aed7b4c1fbf140e51824924e19a3c95f7618194ac7"
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

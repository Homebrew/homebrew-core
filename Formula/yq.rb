class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.9.5.tar.gz"
  sha256 "6b5213acf183db262653ad0790114505281aac025e2c4f140e04877d5c43bd9c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e64dfcdd14238897703edd7e89041fa69d339b1507c4d4e1381baa0dd43bc79a"
    sha256 cellar: :any_skip_relocation, big_sur:       "a08dba0bcb90c7b27fded99af990b87f3eb072d06564e3070250cb337b036719"
    sha256 cellar: :any_skip_relocation, catalina:      "56eb5a60ccb61d2c02eb8759c8d5f139d4b9a9bd1c21a9d65614048adcdce815"
    sha256 cellar: :any_skip_relocation, mojave:        "4a5dd99a7d21b28349ddb6287d8c88173c2f67607a2d6a787db882539a73871a"
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

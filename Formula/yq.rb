class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.8.0.tar.gz"
  sha256 "bc95ceacb4857890363d83c234ed6ca225cec385500f09783de6f91a2ca08ea4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "872da7968c97e34dd215195ca2adfab3cb92ef7f192b36ec6662be73fae3ceac"
    sha256 cellar: :any_skip_relocation, big_sur:       "f99a4129e6c51f1aba0a900a879bb7097d55443e81ab84b1a1d007d76d71eb6b"
    sha256 cellar: :any_skip_relocation, catalina:      "cd975b1440a2e764e9e287969d8ab65321041507a12b7254b70e8231a44e2890"
    sha256 cellar: :any_skip_relocation, mojave:        "bc16de921140af814937d7f483c1edce2742fbda07f48b6677f2b3564e1d6fde"
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

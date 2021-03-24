class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.6.3.tar.gz"
  sha256 "85d7e0cbc12ac690fd86e77bef7a7ce27e0969191a9b6d3bb491ec690659d681"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d009385e9148aa72b3497924457c52980ee07de4469ee2d4e9a06a0c0cfc3387"
    sha256 cellar: :any_skip_relocation, big_sur:       "25e2437b79f765588498eb4909581b36c7b96f7464c8595b6a66ea8d9af89133"
    sha256 cellar: :any_skip_relocation, catalina:      "c99d9403c1b75c678aea588e454ed7c714b2d13ea62d2b20345f4ba3ecf32ff1"
    sha256 cellar: :any_skip_relocation, mojave:        "8b9aec3e4a152a372e0b095ba7ee92b41ee7093aeca36f7f65ec95885d27ffbf"
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

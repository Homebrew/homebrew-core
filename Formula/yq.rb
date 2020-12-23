class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.1.0.tar.gz"
  sha256 "2ff35db36b2d8226d181deb02b8e80ea7f6d4fbe04b7942fc5de2470e91b66d5"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "353f4fa85c7c86a96b642c18cb775476d627d970d896cc2577930a680bc9f99f" => :big_sur
    sha256 "e85c3418aee0e15ef8e011c9983f70433fc6411aeb41ed79a84d5e71508b1045" => :catalina
    sha256 "59c8b2da89654f8ecd6b6718151835b2cf43b9c64c7d6f31790a27ded4f681fb" => :mojave
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
    assert_equal "cat", pipe_output("#{bin}/yq eval --null-input \".key\" -", "key: cat", 0).chomp
  end
end

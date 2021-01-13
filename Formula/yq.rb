class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.3.2.tar.gz"
  sha256 "7e739f3d96dfb508bf52f33741135121363cf1bf21e3a890e5d8a937877881dc"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "1155fbb777da8bd4b86bae16483aac01bc9d12878abf01c07b4c60d51ce54b56" => :big_sur
    sha256 "2944791e1cfddc09d68df13f71efdd2aaa7112fea8d6e7cf25b4163ec377128e" => :arm64_big_sur
    sha256 "e8051fedf6a479b65cc0dded30435d355ab6ddff575b1038186f91f766c2a4c5" => :catalina
    sha256 "ba661f505d8c2705ea36c29f77a3328e2e9e3f65b029407961cd33d8769a662d" => :mojave
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

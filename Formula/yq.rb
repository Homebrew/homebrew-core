class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.3.0.tar.gz"
  sha256 "6b6c816408776d683d554a7aa49a6d48cb5e35843f6ac07b74ed14f20427077a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "11eea0fba7fedb6d81d225fb565592b07f6d685ec7c79709c3a55fef944bbaa1" => :big_sur
    sha256 "e22c1197e212d9dbb856dc0c33486f38d049b727b919ba8124a912247f9c2dbd" => :arm64_big_sur
    sha256 "907a87912a3dc1adf03ee49ed9c9f55e389589a8d23e609f2484164e51fcd5e5" => :catalina
    sha256 "56287df264fa91497d210ad145e57726e75cb1452e8e02ce64b12cf7bce63032" => :mojave
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

class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.9.8.tar.gz"
  sha256 "a7b68382ea04da47c1ef0486140f093ee4578525a89f33c3ba457d424e316cc2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "86933d354cc75a1f38c920eb09b9f5fd19ab75ef9103ed0c4c3c03b0780f5bd9"
    sha256 cellar: :any_skip_relocation, big_sur:       "401e30d25dd8ad585774c6ed1d91eb48a9f0770efcf1b16d8862302658318203"
    sha256 cellar: :any_skip_relocation, catalina:      "cbd88ac9b2e88e2d4b64787705f3ddb8f4007fdf8dbe6510d599c4fa16c2c962"
    sha256 cellar: :any_skip_relocation, mojave:        "a3f9702deda5ccce94aae9da48fe0726ec0a2053bd4b8d50bf1c9ea9c2a469b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ea6e360d532f2ea2162d86fea5fa22375d2b83169bc57935c6ee395ef25a0f8"
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

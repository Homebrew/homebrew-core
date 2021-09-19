class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.13.0.tar.gz"
  sha256 "37c48c300f64c191f7b7e84d9002f6cba464c9437c79a367affe5b2d85f8fd3b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1b8933e6b7c8b233f2e1545d83f2681269dddc822af9e0aa5cc7e1f4b6f2e719"
    sha256 cellar: :any_skip_relocation, big_sur:       "c6839524fe0f8c260b0fe97567905fc321d6058f88f9c083d349fac755cd2dbe"
    sha256 cellar: :any_skip_relocation, catalina:      "461eb96088776f7f94742a4a27e8b1ae8c926750a97400c668295949ed1c75f1"
    sha256 cellar: :any_skip_relocation, mojave:        "498b09bbeca3c88c1074a8cb8f33cd65eccc037e8e0d0058b4abe2103ee10482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b783cbffa97168b5a3da42c0478c0405fe13d22d67b87f9dbd0f679c70abe0f"
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

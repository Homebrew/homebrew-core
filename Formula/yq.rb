class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.12.2.tar.gz"
  sha256 "3a2d0a37fe0b447f585de6a3f59ac3aa85a27b722003cacb1d14e301fb373227"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8468f69c015c4eb4f13a92744ec6dcdd1819cd3e949e6762aa4280ca89a76b2a"
    sha256 cellar: :any_skip_relocation, big_sur:       "70ea92935a9c404b8612fae0e353c328b760231c6e6f5802281787583de225e5"
    sha256 cellar: :any_skip_relocation, catalina:      "7cd9103a69899546b59b57a84c5c8907b626f4b14c74eaf1d1be82a258c63f72"
    sha256 cellar: :any_skip_relocation, mojave:        "36565ec4e5408d3881a51674d96d336f95ce66ab1985bdf2fb6866dabf903b08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f7e9d015949986e0a3d39c0182de4d2cecc50e1fecc164ad7e0da67b4c5dc5a"
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

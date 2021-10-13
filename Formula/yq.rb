class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.13.4.tar.gz"
  sha256 "5d18ce2b2877a42a9765fceb7617f5aae3e0bc4e9f44c3048f9c9928a19bf965"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b127461abef27d22fac10a940aa8183bfc9d4e40d46c45919fb9eaddb0a24b5e"
    sha256 cellar: :any_skip_relocation, big_sur:       "132804bdaa35cb9abb5bcda3a9eb61a19c3e7dd60a068b0b3823b4ca7793a29c"
    sha256 cellar: :any_skip_relocation, catalina:      "1ad4007e6f72148853ed231c775dd206c3d77553616b12e4e7db082ac00de2f8"
    sha256 cellar: :any_skip_relocation, mojave:        "f50045e33bb2d60be556592ff069e96a0e5400819c78a91ddd30f552c51c3cb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76e08a32df1b196fb894136391e81204fea1ed9fa9e99ef42bfb224cc4d31448"
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

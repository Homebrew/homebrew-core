class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.13.4.tar.gz"
  sha256 "5d18ce2b2877a42a9765fceb7617f5aae3e0bc4e9f44c3048f9c9928a19bf965"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9fba13c4869747b891013f65a3dfc377e6ae2ae9e36b1611a18dd908480b7b56"
    sha256 cellar: :any_skip_relocation, big_sur:       "062d0754bcf667c47ba9129a73a4426307fb6dcc05c8bc2e67099f1b18a9035a"
    sha256 cellar: :any_skip_relocation, catalina:      "45a702bedf2d6645825aaeb9a7d0cba25b1745399260ac95292046eec82397ab"
    sha256 cellar: :any_skip_relocation, mojave:        "d6012c74cc8b0e8e8de2e079cecef8a25bca4e9a01d1b8986094059df1120f14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c59bbee899a43ce7a2c6677cf39c77cf4a66ffdd0e3bd2ce1b03674df765099b"
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

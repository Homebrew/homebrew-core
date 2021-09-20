class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.13.1.tar.gz"
  sha256 "5a75c86e19cbd9b7bdf27f3ced7427be3d1a14e71b9339be8a29abfb96b2cdc5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c93129cf06718ce64ac671dc486f4d24f9740a5b57fe017b49def20b18de8d78"
    sha256 cellar: :any_skip_relocation, big_sur:       "d9ab80522f15dbfe43b197ea70592c7cf9b6eed12d183ef40277173aa9f5e19d"
    sha256 cellar: :any_skip_relocation, catalina:      "0adf6f47b4e03c7470f6c1abe91f1aa7e558f8f4e1a72f731ec6ffc14c1db61b"
    sha256 cellar: :any_skip_relocation, mojave:        "3a5cdbca03d5a869377b57d3127673977e769c3f6ecdfdedbade3f7a61942d98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1150b9be9f83877da63ce384289ab4aba5cbb6614bf889510447d16df2428bf5"
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

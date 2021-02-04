class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.5.0.tar.gz"
  sha256 "d8b4da5ac8114b24dc1c89310d8c08b07e5aaa5da7055b04829edd8893ccc501"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "26ef0404bd26d64500a49320244ac4b9825bf3e689672b254bb9aebb2a090120"
    sha256 cellar: :any_skip_relocation, big_sur:       "6c2a34c77ddfe2037bd142721fed1768070c56962247c569230a985e92fa56ef"
    sha256 cellar: :any_skip_relocation, catalina:      "9622d1329b15e4614888d069bc764fef8ad6e23e17ce19fa325b2d5fb91c261a"
    sha256 cellar: :any_skip_relocation, mojave:        "22b786f6edba1a57e334bf8630469791e458ffb6538a9d66cb1897565702a264"
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

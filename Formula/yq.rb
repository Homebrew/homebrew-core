class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.3.1.tar.gz"
  sha256 "d06aff91e97f02aa51a16bd608954d5b9ec35950db1ac06addbde60dd360c9ba"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "bcf6d5c8f29111721d235fdcfd1c044774f9b1003cc4ffe966462fbe8241e289" => :big_sur
    sha256 "0ad163536fbe51151fcf6e87196d528ebae9edfb0cf99687f5b1be8a39582775" => :arm64_big_sur
    sha256 "d32e01248a64c87315290a8b0ac5abec3d485ad5181889cfbf14634467604b02" => :catalina
    sha256 "0fda89ff32c11864247d64a47b0baa6f2a32ce57ce5c0fd753c59bc9d3e25b41" => :mojave
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

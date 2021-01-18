class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.4.1.tar.gz"
  sha256 "bdd078847a74245e4c09af3dc31cdb482588398f342a8db4c019115a8495ebad"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "5619ac0ef0ad093218c393fc2ca52aea3839a136cc1bbf1b109c71f090a85393" => :big_sur
    sha256 "fa0e24c4577a96caadad725096c3df00867a208fcf29b7f2fc08086084ea530d" => :arm64_big_sur
    sha256 "d3e295cdef6093bca1e10b4ee734469679c88abe9321743a441174638222f4f7" => :catalina
    sha256 "ec57fd2062c79771cb00f96ae26945a67ecaf82205cba82b33e2c575966859e9" => :mojave
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

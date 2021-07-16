class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.10.0.tar.gz"
  sha256 "69f2f8de1e0c5a2d6e529b471f47c2cfacf072ee751e936fd81d645a09346f30"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "68d0b76d7723df93e47990c875b971a0e865d4d4716bfc360c0a3dc83d69211e"
    sha256 cellar: :any_skip_relocation, big_sur:       "b85794451226c51e77d84fbcd24f46b5e9925e6cb73ce67b0845e77bd0148739"
    sha256 cellar: :any_skip_relocation, catalina:      "3705044f1ba27b9ef3b129bba414fa539432d439eb43c25e63e8ad1cac93dfee"
    sha256 cellar: :any_skip_relocation, mojave:        "a0aba362f6ce0393b820cdc50cbd89f48d6f73e690ef5245887bb22f89be6f0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2a5db745049167c6e1d32627b0f26d5c382e30f5a4b72fdef9a87fc15c7c21c"
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

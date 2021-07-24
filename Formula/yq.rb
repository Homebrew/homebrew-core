class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.11.2.tar.gz"
  sha256 "910f64ceceabed5f63550a29923c158612be94f2855b0d10fdb549d8ad826a5f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a82c2cb18dad78b39932bd95626c1e7ad8644b700520602c259116c72c7f322a"
    sha256 cellar: :any_skip_relocation, big_sur:       "2f628432c238de97aa6df16708be9cd0f6f11d1a6fbffa3d0191015eb1b55f82"
    sha256 cellar: :any_skip_relocation, catalina:      "54f29e27efc6fe51145860641f953451c99b6cdec6ee6e6cd3909f37973b3f04"
    sha256 cellar: :any_skip_relocation, mojave:        "cfe123d503dc2e9258922fe1fa6c648e023f3d38c03d65db58bd5adba6c8ed78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3b9f179ae859263eeeb105d2940c8a99fd317e8804f5ce93e0957d2afe296dc"
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

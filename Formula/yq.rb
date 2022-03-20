class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.23.1.tar.gz"
  sha256 "f55ffb9c6d7926b06d5862eb6a9e9ea942ec2883286df8e2e3d6f0716cc36eed"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "741170654b5a37db6f6d34508659191a0cc7fb1d93b98e0b059d0a4f28a8b9db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3abab1b1b7f5013581704a3ef71f64ba2e49fe9ac37d14da9bf958b989361586"
    sha256 cellar: :any_skip_relocation, monterey:       "1f07620ad3d86233add86a47e1d0c8fec2ceaa2355beacc579ff608899f3d801"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb250d5848e91e22fe57c693f1949a5d787a9da82abb178ca1587b07877398da"
    sha256 cellar: :any_skip_relocation, catalina:       "73778ec3e3ea8d0c6b754d0c0ac1aa0343dacb7a6a90231b41becf9db3eacb2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ccb791886b6ef0fc80c106fbae6df04169e3bf61c60254872f794c70ae283db"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Install shell completions
    (bash_completion/"yq").write Utils.safe_popen_read(bin/"yq", "shell-completion", "bash")
    (zsh_completion/"_yq").write Utils.safe_popen_read(bin/"yq", "shell-completion", "zsh")
    (fish_completion/"yq.fish").write Utils.safe_popen_read(bin/"yq", "shell-completion", "fish")

    # Install man pages
    system "./scripts/generate-man-page-md.sh"
    system "./scripts/generate-man-page.sh"
    man1.install "yq.1"
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq eval --null-input --no-colors '.key = \"cat\"'").chomp
    assert_equal "cat", pipe_output("#{bin}/yq eval \".key\" -", "key: cat", 0).chomp
  end
end

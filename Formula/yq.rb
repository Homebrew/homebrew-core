class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.20.2.tar.gz"
  sha256 "031c63dd98e564b9a74b842ffe8ae929085f1486f59a27d4feb7e118f40c8a1e"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99d3b705df8f26a58f29496f2b5ba5067f2cc1f78005c4d87a8bb44043dbfe8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50b6be85b70a25771fc2b35ee19f6043d990df9842559e603b87f9e58a876691"
    sha256 cellar: :any_skip_relocation, monterey:       "9ffa400ae273e623b2b6438271851fe2667dd74b64d0810307b79949cf33b9e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "efdc7eff68154fb15907959750a77cb35b7bd2c46ba4412ab3dfcb4832ccdedc"
    sha256 cellar: :any_skip_relocation, catalina:       "966fd25080d771529021aa358d0e6e6e3aa93ddb3aef7096a001eba548675a90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e28219c6bcfebad3b73f2bbff2df22211925e453dada1044415cc61035675bf"
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

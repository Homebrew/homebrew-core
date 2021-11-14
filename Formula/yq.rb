class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.14.2.tar.gz"
  sha256 "2917a72bc0cb0fbd132b3257ff9162db83d129adc5670f7661c29a873684e04a"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9b4f63f3e0e9125a0c547bb7de90dd4f79ed3cc5c976732347f3054663cb4d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3925710394d329be6e7a7639b81389b742393f3e18dcd4bfb9a7b6a08acc7550"
    sha256 cellar: :any_skip_relocation, monterey:       "b732a0258096abb50bae00b13332c84586d9370f5b68328ea0bd608c72d2f7d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2a186db2d97380888eee97684be41ec832115057dd12d58107159b0ab6f3a09"
    sha256 cellar: :any_skip_relocation, catalina:       "0a1091b3e54b4f704fbc77094db805110a3f65999224f998956a9f919d26bad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ca308e471e524c8f9d7ef15827474dc688ddb4352296bb9b109485aac1a1a05"
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

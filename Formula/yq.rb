class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.25.3.tar.gz"
  sha256 "30309ae4efbe8b4f0a26e3c878bac72288faa0ba54f544c7fecdb3e0373966eb"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1eb052e0c8c1db6d1cbb7df84053fc18fe18f46aa4c8010c95751745e8250928"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edfee0893fb5add5ba49929be5859593de842bc0f493860d814fbee6ada233f2"
    sha256 cellar: :any_skip_relocation, monterey:       "8a759a71aee80f337a74507dc2bac54a532171aa0efbaed7c8560ff5f484e801"
    sha256 cellar: :any_skip_relocation, big_sur:        "a321cb52d710077a319c6d4a7f8c5ec6ecdd9eaa1471c271a9df6a2d5707071b"
    sha256 cellar: :any_skip_relocation, catalina:       "07af23f0fa67cd2730b7014c0d2cf1f054f4149bfde691170fd7fafce9283913"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8472e9892556eb5c4b5ba70fed83392fd56ab17d2f0f7319b2ff8a3df7dc05a0"
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

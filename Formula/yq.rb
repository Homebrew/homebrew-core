class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.19.1.tar.gz"
  sha256 "c289cef82668722d1851fd4e70fd7bbfdbf5b6fd358d7bb01a9e06c317dafc58"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "867cf6501fe2f7b202b77fe40c84864965c778424df5e3c6b12f32bb596429ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7684e14e566bac686729e03a58071584d840157e519a901e47f12e4db41272a2"
    sha256 cellar: :any_skip_relocation, monterey:       "621e22749c31b24f16ba18164aba1e96e87f3effd09f8e86991cb8b6fad9384d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b172a2e49997aeba9493a9f3e9a47b00044807d12648b211bf37f2990feadbfe"
    sha256 cellar: :any_skip_relocation, catalina:       "e84b6114ae75377527796e6c59f087d03942d87096f6907f8fd625834a235598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7c12f04a5f629cdd2967d05ae5a1c2d7d66dcfae7673cbe70a6b162c0a6a9e4"
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

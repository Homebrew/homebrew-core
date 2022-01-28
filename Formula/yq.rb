class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.18.1.tar.gz"
  sha256 "9883f6292fc5b2cc697a2f7f7441965948545831265af8dad51a4b12696be086"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce47cec2613725d216139f5cb52efc0f6f1b5e0254ea067b4daccd9c2e0242ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be8185f4e25e0b0aa83c7da11a7412db733382e4caed0d45839a674e2df17408"
    sha256 cellar: :any_skip_relocation, monterey:       "9e73d22e6a47804cb51de5c0d0ca668081d310f9cf0ff81237227ad9faba9563"
    sha256 cellar: :any_skip_relocation, big_sur:        "01be17a4a47e776175986e9f2b3d70a4355505cb25caa97b3d69264abcdac73f"
    sha256 cellar: :any_skip_relocation, catalina:       "1da39eb5d7b56a3334a4d9d3e195085146faf0b6ed385ca16dd992c98a8a6de1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae12b7b7333e74eb16dba1dd9c50ca09f5b7a98d13fda074a5d21e13aea34c56"
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

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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb5a262169242f2fc31c3d1bd6ee867dcc6f12c94111fe1df368ddc7a8a9b696"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4241d61fbd7a4c46164f84ea8127158f64eb08b40210283f795230e30243039a"
    sha256 cellar: :any_skip_relocation, monterey:       "2bb58a0ab69057b26b2eae2b66ecbd85a6f6bf261301c60202503df22fe46915"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8b1a612f88cfa597c55e19d175d75a670eff8b0c3cf739c719dd2248b6c3fe4"
    sha256 cellar: :any_skip_relocation, catalina:       "c56056ff92fbec83d2b0497d42e45e7c27b195e2433482226314c5a03b799d6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86b472a1ab4edbf67cd966eb191802d6fbf5df2403ba8f5ca50a2b7a734ce82f"
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

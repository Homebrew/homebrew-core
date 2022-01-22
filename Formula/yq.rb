class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.17.2.tar.gz"
  sha256 "a1bd57ef70e9a8457b977de006d2904fdceae462eb548e8a89de8f1b1b727369"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bab71abf2975450aea8c03937d5d75ab7187200ce8a620f46f47a3b7bbe336e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "757b0579327ee1a1251355d36a71a8c8c2709d39e9fe0e1bfb9fb6a19c0e49f6"
    sha256 cellar: :any_skip_relocation, monterey:       "1053660a36d202eaacb3c62f6a7362488a460bb88eb4ebb46267899809a0c08e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ee0af9446537e84b3a386f91f758477fae8c55f7fcb20b5f8690b8ffe777d4f"
    sha256 cellar: :any_skip_relocation, catalina:       "97a0987b584467729fcf11c00674b0f62b862a2abaac468c444dbdd234a0d498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a12d2bd47ade2075aa8bc6eec30e8e0d1956308d1a2a4156732488228bbde5aa"
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

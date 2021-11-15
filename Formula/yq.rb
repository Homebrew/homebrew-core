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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32387618451b01e424a05f17b5be73765b4c56d31312d4f208c253ea0e1ad5fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "679247ab1166aecdce6a4415b7b68465315ecc98ce2f57412bd20819f56f0965"
    sha256 cellar: :any_skip_relocation, monterey:       "93a97ac2d725d37191b5996d832e5c61bfe99a40a0de71f0ffe90c59beaf825d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7c6ba65210719050cf219437335c94f749d60a038895b55039118036ad076c7"
    sha256 cellar: :any_skip_relocation, catalina:       "6f12ee9e73b21ae8bf4569042920b506a5c2b0f9689f5579067c85e85ea85dc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccf591dd45784ca22349b9a572ebc424c1f2ce5d933b37ae88c6435e92d20b84"
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

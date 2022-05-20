class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.25.1.tar.gz"
  sha256 "2f0736f0650bef121e31332e1f52c67e9bd975ca651e1507a2e5e3744c10e766"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e6eeb5167f52d0071740428d7ca68709467bda65f71d1702ee5fd66cefccab4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03b33b507f688c42e644467004a5a1cda6ea432f303e5b5ce3e08c80796dda02"
    sha256 cellar: :any_skip_relocation, monterey:       "7bef84e81b9e6758d559be55977313a514f1280ab9e72234c5ff30a5d1c71bf3"
    sha256 cellar: :any_skip_relocation, big_sur:        "11fc1c620c919696ffa19b8a63c1760c92e4dbebbfa0bf39465f7a6c61ed5a31"
    sha256 cellar: :any_skip_relocation, catalina:       "ce5231cc3fd538eb959675e29e65af6571fb97c481f2695c6c76f7bdf8db789d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "849fce23e6abf66516e2c9247f03519e865ce2519514d1b23718bc5611a1ce36"
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

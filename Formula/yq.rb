class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.27.2.tar.gz"
  sha256 "7df68d38bd93804fe13dc61629453b6ef4f82d55287cd0d635efc41ff99cb5f5"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4f666133ab3cdb1cc06fb7d1f4cb9f68c8b0a9db431084cd2c95c165c83e502"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34c7261bb0b2a8b72bea21fbcb500c485eb042b6406655fe07486eb218bff046"
    sha256 cellar: :any_skip_relocation, monterey:       "3484ff68132befa63c83d6ae21113b3a10983f8cad19cc95898f2844e1e5168f"
    sha256 cellar: :any_skip_relocation, big_sur:        "31a5efdd8b67f4e530317ccd63fe89c4de7b8fa0935eec88d764b3bf941c4a2c"
    sha256 cellar: :any_skip_relocation, catalina:       "1459fb4830bddd5acfeea2bbde7e7d25419c1894ff0f1811cb1a566fdaa7b14a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8673c42d7e961b5b4809159e22a63e59b85dbd2979ca0f97befd6f1695975b54"
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

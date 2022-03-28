class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.24.2.tar.gz"
  sha256 "f85a01a3ed50c356d44e974224cf2be48039c73be65e9c8fe50d780fafa40f6d"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1be04f9bef57010dacdd998eccab9cc024bfe2cd50c489b2f0cced187f1db11c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a67f0d0563da2ecd8a7d8022056df07d61587810ea667abd864b552008974a03"
    sha256 cellar: :any_skip_relocation, monterey:       "4074473eb7712d0f2de168b90861108c1436a502382bb68baa75f312dc2ba2d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "c186479d40c55e4e25aea66cab06eb8676eda113dd3ddd91a505530b64852752"
    sha256 cellar: :any_skip_relocation, catalina:       "000cf444ffa3058b2658972ea144e662abd45488f1af67d6c86fb722872555c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4c6fcb0f4bd82294f38975e895f2232c33e474a81335750fd70c1882b29bf3b"
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

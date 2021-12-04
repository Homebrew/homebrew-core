class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.16.1.tar.gz"
  sha256 "e96eb45992849d2e90f2f96b39dc713c345adafb6db551644118e58192565dd9"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba1453eec173665d4f778703d576591437265ce7e304410f139e528fd25e3e33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20649dbb614115b3d78fd8408ee300edafc5dd3580b9e786819de2204b59012b"
    sha256 cellar: :any_skip_relocation, monterey:       "415da59e3f6f589a464fe32216c551eb2d3b4f495d6bae6d97e776dbee92b289"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e2306bec4a965f457e7d8689e268a8cd03b73cdc658e21f602774256027fb45"
    sha256 cellar: :any_skip_relocation, catalina:       "5603e01ae82465b7010976c945717b0ba82eda1df2f32e9de2aace9480558a2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11cf550de7b264e28eebf82890831b717c2934f1947f1a65521b251aaf84615c"
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

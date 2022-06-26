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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a51f984484b886579eaa31e14ff0a67ab2c9b101d1f36b8abb382747e714616"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4067010ce00450e8587c43c01a3d679f0d6bd73a9e8cf951bbdaf6cc883659a0"
    sha256 cellar: :any_skip_relocation, monterey:       "fa12ba91c1b54a0d8270a8bd8e4e36440bd8af32c44792ce8472c3812ba218f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "afc311123a9b65fd521206344aaf73d479e67e0f5dfeeaa9ff891416218f2133"
    sha256 cellar: :any_skip_relocation, catalina:       "8ff4c3f2ee18f86707970f0f3afbf6c787733b11ffdf6a78aae927d387262030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46bd4282c6b951043a2c40cf38188b2af78f5fb8ce94fa2f916c0071f9eb5dfb"
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

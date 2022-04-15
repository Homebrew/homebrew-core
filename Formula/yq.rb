class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.24.5.tar.gz"
  sha256 "8ffab12d2d527f0ac62823777201f8e5e78c9af5c754914274db2733da98c796"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b01299873baacfd96bb0970c8b65b77ff6eac89f3b41ff69734a2247a0896cff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31a6d39f608b70ba69df99e317098e37ff62b1928e1071755d9b6c3503fc95bf"
    sha256 cellar: :any_skip_relocation, monterey:       "e99a7dbad848e8b346c45518166fb950b9dcfe017552c2d60dc7a38edae325f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee8a090647c0a7a2629b6dfdfe82701529b440599b3f08eead58c0610e2ba264"
    sha256 cellar: :any_skip_relocation, catalina:       "08ad61487beb9d125fb751716df14f4f40a07df086b151753c450f717264daf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61c771a54ab98059dbda9d5a39e30e5bd80073cb835148cb177603220b893e1f"
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

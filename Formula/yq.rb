class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.33.3.tar.gz"
  sha256 "d039424a5df2259f02352c1587696293811138d01152b3aec41977ada399f19a"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd365dea330bbcabf66a41d68186fb980396453a0d4db0718a79fbe192f5aee3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd365dea330bbcabf66a41d68186fb980396453a0d4db0718a79fbe192f5aee3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd365dea330bbcabf66a41d68186fb980396453a0d4db0718a79fbe192f5aee3"
    sha256 cellar: :any_skip_relocation, ventura:        "f2f7fb5da1f23b6caf80f7950339729e68c144c3739776226f5622217768fb74"
    sha256 cellar: :any_skip_relocation, monterey:       "f2f7fb5da1f23b6caf80f7950339729e68c144c3739776226f5622217768fb74"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2f7fb5da1f23b6caf80f7950339729e68c144c3739776226f5622217768fb74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fb22f116d787625e7bc9f6ed0ac9f81d23878917ebceb6e005dc176da22dabb"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Install shell completions
    generate_completions_from_executable(bin/"yq", "shell-completion")

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

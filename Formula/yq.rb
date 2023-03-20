class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.32.2.tar.gz"
  sha256 "769b77a01fe8c389b17b3a5eb606a395540eb7ccdc533e2db2542baeceefcbc9"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c91f74c7ee0996c288be3f77b484a53eb1d44b46fe9e153e5205d4814ca091c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c91f74c7ee0996c288be3f77b484a53eb1d44b46fe9e153e5205d4814ca091c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c91f74c7ee0996c288be3f77b484a53eb1d44b46fe9e153e5205d4814ca091c"
    sha256 cellar: :any_skip_relocation, ventura:        "2f5ce5812c280d578bfb0642a0fd5e6ccb3191db36d5f4ef7dcb8070158297a5"
    sha256 cellar: :any_skip_relocation, monterey:       "2f5ce5812c280d578bfb0642a0fd5e6ccb3191db36d5f4ef7dcb8070158297a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f5ce5812c280d578bfb0642a0fd5e6ccb3191db36d5f4ef7dcb8070158297a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e21b6406de0fc70c14e91c10fc996a667ecfdfaa2124e69a34b801817970c72"
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

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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20e85b139b301e5a7e19bcc08582a00866278f6584866f6f5d4cce41a90007fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20e85b139b301e5a7e19bcc08582a00866278f6584866f6f5d4cce41a90007fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20e85b139b301e5a7e19bcc08582a00866278f6584866f6f5d4cce41a90007fc"
    sha256 cellar: :any_skip_relocation, ventura:        "e570a45b1c719a3c458316d9da6422635ae9d469ecc7d551e1d9dc8d4fc5b454"
    sha256 cellar: :any_skip_relocation, monterey:       "e570a45b1c719a3c458316d9da6422635ae9d469ecc7d551e1d9dc8d4fc5b454"
    sha256 cellar: :any_skip_relocation, big_sur:        "e570a45b1c719a3c458316d9da6422635ae9d469ecc7d551e1d9dc8d4fc5b454"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dd981a247042231395be9a5ad2afe59e62f579a96dcf518812194b542d58e51"
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

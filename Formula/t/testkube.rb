class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.17.7.tar.gz"
  sha256 "a944a5177f03531c048e5f406a150996fe4660f6ad69145d1ff586e3caa90414"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc0df81e681bd7720f269f8d5f2cf6aec27337f6ff705903a1b6e1abbd874195"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cab443512158f4faa0e0510c58c6e57909323adbd2a1c26a8ed0b6d2d863cd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c54f90796a6ca4f9905fc97f3f979509a1bec59c3610455d02fbb8c8ae33bbe"
    sha256 cellar: :any_skip_relocation, sonoma:         "18fd8580774d06a91ea85e23993871bd6f38950b694fbf5bc0c6233c0c42cce0"
    sha256 cellar: :any_skip_relocation, ventura:        "0892d737973c024ef39a23d5340c3f8878e5b1c589f4ce70677cdcfec6e30e50"
    sha256 cellar: :any_skip_relocation, monterey:       "7705c9e6065ce5c22099d84b1e559f3996b69f1f2c9f356b0072a1d280bf4f6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcb0ed6d62fa89f0c0a5fac5f66d4b94b7cabe70eb99e65b88548b302f26860e"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags:),
      "cmd/kubectl-testkube/main.go"

    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end

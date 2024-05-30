class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.17.51.tar.gz"
  sha256 "edfdc0a3eb08f5f222370bdce6d94162afd82733b9c77712694f5102a7bb3cde"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "254ba99f8b9bec06a7a9e9b10f18f8535d9da947826798f285f289f975649113"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "244bc3c592d10e976fb3a8c510527d289cd942a8ac72e428d8554318f3b9b831"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9714459d8e0fc1804ac46f88e97352eee300387093f98cac095bc5ce6e9e144"
    sha256 cellar: :any_skip_relocation, sonoma:         "85cdeae3cbb75685da43b4420d5aa8e6d2f986b30acb9d29636f3ef8e5d8642b"
    sha256 cellar: :any_skip_relocation, ventura:        "1ccc6ae27aa6b9b1bd2d11d5e9d496e543419dbb0f52ab4ad837ece4b599ea8d"
    sha256 cellar: :any_skip_relocation, monterey:       "611322b5d6b997f62497b9f14834feee10e0537adece1044da0c094185e92541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "455f36b06eee9ab1430c7402ab1623764918c8678c6a4a196622922256c0f61e"
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

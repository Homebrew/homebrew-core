class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.1.17.tar.gz"
  sha256 "ded8e39d373695eb32588c53fbecee7507bbf57afb3bdcbcf1153cdfd1ee606b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "000d5ad39098705e06313a48a62a3ef561641c361be42df4ae3f60aac1ef3647"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "000d5ad39098705e06313a48a62a3ef561641c361be42df4ae3f60aac1ef3647"
    sha256 cellar: :any_skip_relocation, monterey:       "e505f53b6abfe5b6ca7e76c951334aed7fff2ec6782b2fd1d9762b9a6acf9498"
    sha256 cellar: :any_skip_relocation, big_sur:        "e505f53b6abfe5b6ca7e76c951334aed7fff2ec6782b2fd1d9762b9a6acf9498"
    sha256 cellar: :any_skip_relocation, catalina:       "e505f53b6abfe5b6ca7e76c951334aed7fff2ec6782b2fd1d9762b9a6acf9498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8012813e2194d1230de8b6fafa9fb2d84f9bff27677164f1b2917acd9788a2b4"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags: ldflags),
      "cmd/kubectl-testkube/main.go"
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("error: invalid configuration: no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end

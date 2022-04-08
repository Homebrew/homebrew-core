class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v0.11.19.tar.gz"
  sha256 "382159a6a58a98f13244b8899f65fb0983b89a77760c5968cc46231dde5a4e93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c10f5912cf295a1add085d3c8ef604a26cd936c8ec832a6f1d29b67206d01669"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c10f5912cf295a1add085d3c8ef604a26cd936c8ec832a6f1d29b67206d01669"
    sha256 cellar: :any_skip_relocation, monterey:       "4e9564bf8655e8727dada91f9219318ece8edc76816a469e554eb2d156d77035"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e9564bf8655e8727dada91f9219318ece8edc76816a469e554eb2d156d77035"
    sha256 cellar: :any_skip_relocation, catalina:       "4e9564bf8655e8727dada91f9219318ece8edc76816a469e554eb2d156d77035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca6c433100b257f0122a46aa156fc194bfbef967fbf2a6216c2b0f8b627f9e17"
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

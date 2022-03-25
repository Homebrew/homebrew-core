class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "ccb12506b5796229a015d7b34dff7f90aa49df15c27a54a62d535ea95d4a83cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f9fec7c90ba33cde6fa4427c6526395386eb086854fed9aad9a47e887d2b546"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f9fec7c90ba33cde6fa4427c6526395386eb086854fed9aad9a47e887d2b546"
    sha256 cellar: :any_skip_relocation, monterey:       "a451ef3cb2c125eed851d74135c7b859f1cbac9fbb1e405f5feb1999103bab26"
    sha256 cellar: :any_skip_relocation, big_sur:        "a451ef3cb2c125eed851d74135c7b859f1cbac9fbb1e405f5feb1999103bab26"
    sha256 cellar: :any_skip_relocation, catalina:       "a451ef3cb2c125eed851d74135c7b859f1cbac9fbb1e405f5feb1999103bab26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1d492fba0e2ad0ebf22e28ec53d09a19a2c90308a9abade933e0b7df769d90e"
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

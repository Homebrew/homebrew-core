class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "ccb12506b5796229a015d7b34dff7f90aa49df15c27a54a62d535ea95d4a83cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7b4118f2e5404153baf17acf1ac0acc0442fda808eb4622fc44df74dfda96b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7b4118f2e5404153baf17acf1ac0acc0442fda808eb4622fc44df74dfda96b2"
    sha256 cellar: :any_skip_relocation, monterey:       "022e5c03c88837b636ce2d168ec27e82b49b3e7db64f3978c52c875f24674a40"
    sha256 cellar: :any_skip_relocation, big_sur:        "022e5c03c88837b636ce2d168ec27e82b49b3e7db64f3978c52c875f24674a40"
    sha256 cellar: :any_skip_relocation, catalina:       "022e5c03c88837b636ce2d168ec27e82b49b3e7db64f3978c52c875f24674a40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea86e9ccbb60e37be90207c8858b834348f32046862eba59bfde0a63166696c3"
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

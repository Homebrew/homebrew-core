class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.24.tar.gz"
  sha256 "88752b8fec8de13bd9d98ff6eb82d8cf59284cfacd5b95061505d46dca0a2642"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44f60367e4a6324d82c2dd659937497aad9326ce7c1715b6311b8c1319123f50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44f60367e4a6324d82c2dd659937497aad9326ce7c1715b6311b8c1319123f50"
    sha256 cellar: :any_skip_relocation, monterey:       "4b222cb515c394fc129b5d32c0d9e0fcf98b00303c25cfa04e4d210d4151e2bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b222cb515c394fc129b5d32c0d9e0fcf98b00303c25cfa04e4d210d4151e2bc"
    sha256 cellar: :any_skip_relocation, catalina:       "4b222cb515c394fc129b5d32c0d9e0fcf98b00303c25cfa04e4d210d4151e2bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a8904490c88b5b0d3e2c2569052747d4775d4620bd1fd29bd6c9f698fa4f967"
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

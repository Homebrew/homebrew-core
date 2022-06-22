class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.30.tar.gz"
  sha256 "179d1d5eda13e10dcf126bbbcd534e43067d9a794251a45fabb87052d368cb8b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ad896ebad9ff9eb71accdf115b807c38331a52a0da8130ae7e2037322454b44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ad896ebad9ff9eb71accdf115b807c38331a52a0da8130ae7e2037322454b44"
    sha256 cellar: :any_skip_relocation, monterey:       "794a30204ba00cc5dc3e69e0cbefefa9fcc741356b7d7db95202cb11185ac0a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "794a30204ba00cc5dc3e69e0cbefefa9fcc741356b7d7db95202cb11185ac0a0"
    sha256 cellar: :any_skip_relocation, catalina:       "794a30204ba00cc5dc3e69e0cbefefa9fcc741356b7d7db95202cb11185ac0a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bd29fa978ae9845b85f334cf4f7152730b4544e331821a3f3c16b5343c34c63"
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

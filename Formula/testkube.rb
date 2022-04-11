class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "fe80beb4543650c867700695b0c6ae397cdcd1a849668031e69ba890891160fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "207690cb2f40a33f11a9e8ff36ebc4fe0d1c59faebd08ea8574be6a218cb9405"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "207690cb2f40a33f11a9e8ff36ebc4fe0d1c59faebd08ea8574be6a218cb9405"
    sha256 cellar: :any_skip_relocation, monterey:       "46a3d33a81c386b5197d9d9e411f6e4cb3ee8648f82d14c27a108b4a07775669"
    sha256 cellar: :any_skip_relocation, big_sur:        "46a3d33a81c386b5197d9d9e411f6e4cb3ee8648f82d14c27a108b4a07775669"
    sha256 cellar: :any_skip_relocation, catalina:       "46a3d33a81c386b5197d9d9e411f6e4cb3ee8648f82d14c27a108b4a07775669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47d1f75d9cc1c5f08537a143dbe9f1b7d15f8a8d3705e4cd3b2903f033ac9f93"
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

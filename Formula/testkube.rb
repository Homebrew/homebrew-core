class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.1.12.tar.gz"
  sha256 "93298a01e412b6e0f75389ac507d41580dbf853f548031628f0911245c1390fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12c51d3b1fbc8261349bcb087b37b84242ca632a8650df5fe8aaa850cd36b2c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12c51d3b1fbc8261349bcb087b37b84242ca632a8650df5fe8aaa850cd36b2c0"
    sha256 cellar: :any_skip_relocation, monterey:       "e27730f51462217074ee6e2a09226727c3d45859034e2841b049b9c4bfebb6ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "e27730f51462217074ee6e2a09226727c3d45859034e2841b049b9c4bfebb6ce"
    sha256 cellar: :any_skip_relocation, catalina:       "e27730f51462217074ee6e2a09226727c3d45859034e2841b049b9c4bfebb6ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b1545af15a9968f001edf0fd9bdb3105838c9c0b8879344de89cea4abdd2447"
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

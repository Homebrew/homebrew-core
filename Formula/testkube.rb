class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "2ed3b9f47b01aa76af9344dba0f525a5e4ba183a07895c8941c7c6d4cba9c516"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c007ea77b0a148cec95ef03029cd89ebff3cc55ea9bbe27be6c1926eff4a10ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c007ea77b0a148cec95ef03029cd89ebff3cc55ea9bbe27be6c1926eff4a10ac"
    sha256 cellar: :any_skip_relocation, monterey:       "91f313c3f7747609f685f535b179486913ced253077a72353c0f44dd2254d8a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "91f313c3f7747609f685f535b179486913ced253077a72353c0f44dd2254d8a5"
    sha256 cellar: :any_skip_relocation, catalina:       "91f313c3f7747609f685f535b179486913ced253077a72353c0f44dd2254d8a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad63fb91f13c796aa2cb541732c2a06df1fd2ffee9d08a1fc7eee7aa882664be"
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

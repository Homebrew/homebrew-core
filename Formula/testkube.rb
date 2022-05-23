class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "0ffcefde2f3bf49ee54befdf6067c95688f853933e75de42755ae86093519331"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b787ee633712918fd1dded94852b09bf102f82348d657ec47fb539e2644ea4ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b787ee633712918fd1dded94852b09bf102f82348d657ec47fb539e2644ea4ab"
    sha256 cellar: :any_skip_relocation, monterey:       "f89487f0c4893cc8cb7e13bf81ff693420e6c0d39681064ad0fe35d3f05a09de"
    sha256 cellar: :any_skip_relocation, big_sur:        "f89487f0c4893cc8cb7e13bf81ff693420e6c0d39681064ad0fe35d3f05a09de"
    sha256 cellar: :any_skip_relocation, catalina:       "f89487f0c4893cc8cb7e13bf81ff693420e6c0d39681064ad0fe35d3f05a09de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c0b4a86f46e5c766508023862b467847ab3b1b85fa2cd8c3e2da7fd2616d266"
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

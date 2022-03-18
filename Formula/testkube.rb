class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "a0679086568557a376de80abc0af5e79dc95a60d71060696c7f76d4c4da77bf9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23a8bbaa7d6d2423dd1db893d1ce40566114c44547189f9566c3aeca710dab48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5baa803cc8fd24b47ff69df4c5c645dd76a9d02bad152281e2d502c6ec49cc1"
    sha256 cellar: :any_skip_relocation, monterey:       "088ac9080cabda5f536cfcbd343689d791df0c9283f573eba9ed089f87ab79e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "a527858be24a9a135723e98b8e62b77808cb7309bfd65d216cc30a1ef12feb88"
    sha256 cellar: :any_skip_relocation, catalina:       "5a385964bf56d4de4e7a459784c126fbba17d026244cd143d9602dbfd7ae767d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7058becefc97666574a2d04b6d98c2628ac737893b951a368e4a0fddaab8570c"
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

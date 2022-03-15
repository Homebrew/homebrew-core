class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "ddcc802c4150bf456dcc3c4b0a3323675ad41e4b200908d4eec23aadb27063d1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e0252d864bee4bd7a4de4a5f69dfea1c62ba392bfc5f2298df3a08e2c68790a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "271c56faf2d0a065e6ade1de2d630a52144da0273c32d6209cbd492802c7b22f"
    sha256 cellar: :any_skip_relocation, monterey:       "274630c17102f000f936a2916f30c0a28b1a6a95dc95380523c729f9fa2edaeb"
    sha256 cellar: :any_skip_relocation, big_sur:        "61a616d4926195784cea1c44672615807f267d4aedcb1bfceeb27fdc74223a13"
    sha256 cellar: :any_skip_relocation, catalina:       "daa4d10cf3ab346be167fdffceaadd51ac0672df9e9cb6321e14caed5de5800a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26bc1863d5ba6496b7e50d9f6a90ba2d3b8fbf73a4656c565ba0f3a9ea946fd8"
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

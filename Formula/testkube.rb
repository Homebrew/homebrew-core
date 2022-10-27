class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.6.25.tar.gz"
  sha256 "1bc3133abf46c93a99ac58137e9734f6d48a810d91e4b97f8034747763a4cef2"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d602ed6baa3cdb23ef3106e6b1b8647bc3f2369cde55a9b5189dee473584dc56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d602ed6baa3cdb23ef3106e6b1b8647bc3f2369cde55a9b5189dee473584dc56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d602ed6baa3cdb23ef3106e6b1b8647bc3f2369cde55a9b5189dee473584dc56"
    sha256 cellar: :any_skip_relocation, monterey:       "c8f433de2f0bb720fcd6375db120c2fdfd318d96ff9e2434b46a2ac9b0875cbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8f433de2f0bb720fcd6375db120c2fdfd318d96ff9e2434b46a2ac9b0875cbc"
    sha256 cellar: :any_skip_relocation, catalina:       "c8f433de2f0bb720fcd6375db120c2fdfd318d96ff9e2434b46a2ac9b0875cbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "041ef2d165b2fcd37b6b28a56ef6ba9d5b999f4035b5829b2641a436f014d16f"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags: ldflags),
      "cmd/kubectl-testkube/main.go"

    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("error: invalid configuration: no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end

class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.5.3.tar.gz"
  sha256 "05d960c65f4ea82fd6508ea0a4a12cd43fa7b597e4b3ca2a289f4b2d22ab1174"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "844cca5a8de24b3ca886b229f1536202f730908c3466611c25ff651c6e08f2d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "844cca5a8de24b3ca886b229f1536202f730908c3466611c25ff651c6e08f2d3"
    sha256 cellar: :any_skip_relocation, monterey:       "1e72df47d5f746b52dbdf7bbc1c6363856d65ff17b29693b5281311530845dfb"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e72df47d5f746b52dbdf7bbc1c6363856d65ff17b29693b5281311530845dfb"
    sha256 cellar: :any_skip_relocation, catalina:       "1e72df47d5f746b52dbdf7bbc1c6363856d65ff17b29693b5281311530845dfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c67db265ca1b513d2202e9f1fdfea7e7df90f2193c769a5ece28f8eb4ab25eb"
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
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("error: invalid configuration: no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end

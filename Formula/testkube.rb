class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.1.15.tar.gz"
  sha256 "fb84b437ffce04fc06bc8abf6c21b1ce6f06d4080267832cff4ee085798faedb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f683c2621a5159829343c45a56d91065a71125348309671e0ea7e269160b3818"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f683c2621a5159829343c45a56d91065a71125348309671e0ea7e269160b3818"
    sha256 cellar: :any_skip_relocation, monterey:       "a6abc268ecadacc82acd5e2df155d31a259143e304770c371862fbc93c01b919"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6abc268ecadacc82acd5e2df155d31a259143e304770c371862fbc93c01b919"
    sha256 cellar: :any_skip_relocation, catalina:       "a6abc268ecadacc82acd5e2df155d31a259143e304770c371862fbc93c01b919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eefc8dd20d30bb11c3402dd492a0c883819e475f2b5ae3c5d3e1b841f55e76b0"
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

class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v0.11.10.tar.gz"
  sha256 "1943bbdf72ec68154c080baeba93d190258a6703ac1ddc74ea217c1b89f3db79"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9ed83715c53afc6959d6399874e526c775ccc3ed9786c5a690710f43f9ddd26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9ed83715c53afc6959d6399874e526c775ccc3ed9786c5a690710f43f9ddd26"
    sha256 cellar: :any_skip_relocation, monterey:       "2260795ec0372fd32dd5022be90ed75149cb5c823cf71d1a49a463426860a516"
    sha256 cellar: :any_skip_relocation, big_sur:        "2260795ec0372fd32dd5022be90ed75149cb5c823cf71d1a49a463426860a516"
    sha256 cellar: :any_skip_relocation, catalina:       "2260795ec0372fd32dd5022be90ed75149cb5c823cf71d1a49a463426860a516"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6bbc3178d0c476265d2586b94d4be4004ff6d60db320d21cc5984a12bee5eda"
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

class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "065ad36d885fb9bae7469c4e2c6dc421beaaaa043a828513db5284bbfc815159"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9b1b4b9a524486d3c91002921df7fbf5dea9141db67a6e85d497695c40c0a56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9b1b4b9a524486d3c91002921df7fbf5dea9141db67a6e85d497695c40c0a56"
    sha256 cellar: :any_skip_relocation, monterey:       "fb628cb6fb666998adf05e6285b73922d3d1f21e157fce636ee374ae4bff6605"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb628cb6fb666998adf05e6285b73922d3d1f21e157fce636ee374ae4bff6605"
    sha256 cellar: :any_skip_relocation, catalina:       "fb628cb6fb666998adf05e6285b73922d3d1f21e157fce636ee374ae4bff6605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02568a5e438f197dbcad2924cb9506788ef81722a8d3ad295d1ed318b266c872"
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

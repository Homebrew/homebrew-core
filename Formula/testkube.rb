class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.0.12.tar.gz"
  sha256 "dbeb6867b0101dc7f2996a6250f8e23fd336e908d3787a90086b957bd3a23318"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a506e76afb31fd1fdc6e6b514fa587dc1587102721aeddd5c99462a257ac2ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a506e76afb31fd1fdc6e6b514fa587dc1587102721aeddd5c99462a257ac2ef"
    sha256 cellar: :any_skip_relocation, monterey:       "7b4de756544a7ddc8f21820ab774b1bcf294a480b4efe58f5d03ebfb3bd49c46"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b4de756544a7ddc8f21820ab774b1bcf294a480b4efe58f5d03ebfb3bd49c46"
    sha256 cellar: :any_skip_relocation, catalina:       "7b4de756544a7ddc8f21820ab774b1bcf294a480b4efe58f5d03ebfb3bd49c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e461618374b8bcdbcf0def0138d230002d787b6e8858fa624aa7e5abac6f78c"
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

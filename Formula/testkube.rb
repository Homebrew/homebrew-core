class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.7.30.tar.gz"
  sha256 "cba63bc72b22c8d6e91a01b7897e2179a19b7920c5143968844a742930712dfe"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41af8b6f6c07ebd9a64a04b6090d0d83fbaddfa3f059204cb8ba9420868cd4d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41af8b6f6c07ebd9a64a04b6090d0d83fbaddfa3f059204cb8ba9420868cd4d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41af8b6f6c07ebd9a64a04b6090d0d83fbaddfa3f059204cb8ba9420868cd4d8"
    sha256 cellar: :any_skip_relocation, ventura:        "684ba5707a63725378df0a50e14f66bb0b8c565ab5d01ef7d1847594101c0698"
    sha256 cellar: :any_skip_relocation, monterey:       "684ba5707a63725378df0a50e14f66bb0b8c565ab5d01ef7d1847594101c0698"
    sha256 cellar: :any_skip_relocation, big_sur:        "684ba5707a63725378df0a50e14f66bb0b8c565ab5d01ef7d1847594101c0698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9439469faa8c283d8ded7e5c53cd862519269941b0c81caeb15c43ff8ac759dc"
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

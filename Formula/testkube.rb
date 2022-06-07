class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.14.tar.gz"
  sha256 "c3609b7727efccdd70e62339c9af99dfdd02630f877bb04b7521ac164f0e7147"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f74e38cd4471017a8e8bfa1b590f07768edd557ed7c7924a9bc744ec5ed37f0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f74e38cd4471017a8e8bfa1b590f07768edd557ed7c7924a9bc744ec5ed37f0a"
    sha256 cellar: :any_skip_relocation, monterey:       "8318a774c43b0ab29cfeded706a8df25e2ded3416025904841a03f960a7e416e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8318a774c43b0ab29cfeded706a8df25e2ded3416025904841a03f960a7e416e"
    sha256 cellar: :any_skip_relocation, catalina:       "8318a774c43b0ab29cfeded706a8df25e2ded3416025904841a03f960a7e416e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce17adb0f75138f6c5fcb4deb2eeab81987ab8113d71937c0a07301f81bacb02"
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

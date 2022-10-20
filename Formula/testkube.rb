class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.6.20.tar.gz"
  sha256 "2e585bd4c3886d70cac5a55e7a11aa8deca3560152a212fdb142fe4d85135752"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a10e5388cfec8d57f40721a7c9c7e5ac2f7d3b566cc34d930882bed645257c3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a10e5388cfec8d57f40721a7c9c7e5ac2f7d3b566cc34d930882bed645257c3e"
    sha256 cellar: :any_skip_relocation, monterey:       "f8a798b38fec5c3a25846591b4cb56cfd2f1acd87e3d8300de664212dae259d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8a798b38fec5c3a25846591b4cb56cfd2f1acd87e3d8300de664212dae259d0"
    sha256 cellar: :any_skip_relocation, catalina:       "f8a798b38fec5c3a25846591b4cb56cfd2f1acd87e3d8300de664212dae259d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7f0f02fe30de9b01fce961c27b31f2d5e02b8748bf072f808f56390d7b47d86"
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

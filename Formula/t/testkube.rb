class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.144.tar.gz"
  sha256 "f15d1045ee489473682a55ddb9716f305fea670511dc97fd820513c0bb73e53e"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be7758cbe21a28ab238b71eb17b3d4310eef0a13191938ff3a7825b3c972c294"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be7758cbe21a28ab238b71eb17b3d4310eef0a13191938ff3a7825b3c972c294"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be7758cbe21a28ab238b71eb17b3d4310eef0a13191938ff3a7825b3c972c294"
    sha256 cellar: :any_skip_relocation, sonoma:        "f962288a68de97f73ee81325164b5f0507078cdf69708a12c028e35df7ecaccf"
    sha256 cellar: :any_skip_relocation, ventura:       "f962288a68de97f73ee81325164b5f0507078cdf69708a12c028e35df7ecaccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "948d4eec3119764d83b48616f5eaf090a7e2a06b662e19b9181823de08f8f3ea"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end

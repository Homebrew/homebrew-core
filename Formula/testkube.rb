class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v0.11.8.tar.gz"
  sha256 "5a326a7d069873b776c690fdb22f342764e6bd3be6eff9ea28d482a5e20d9e13"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d14ee36f94d1c6102cc1da599b63523b56b8bb8113a07fd35e3fc1d26856139b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d14ee36f94d1c6102cc1da599b63523b56b8bb8113a07fd35e3fc1d26856139b"
    sha256 cellar: :any_skip_relocation, monterey:       "85612bbe9ad9a9aab269102e4acbdceaf61477d25de3d865b153e24eb52d63d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "85612bbe9ad9a9aab269102e4acbdceaf61477d25de3d865b153e24eb52d63d4"
    sha256 cellar: :any_skip_relocation, catalina:       "85612bbe9ad9a9aab269102e4acbdceaf61477d25de3d865b153e24eb52d63d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97eda5f3d1c40f81383759f2e10f86962fb29cecf292a0337a9e9ef59ac792b2"
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

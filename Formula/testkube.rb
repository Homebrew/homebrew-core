class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.6.10.tar.gz"
  sha256 "bc9383cff166801511b0c793860cd732e896a7c951a34b7da85f277c3f2d65e1"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a36dc9860ad91dc64cec20b968c3b07fcb324f2f6ee42351a65c6b2156f8c10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a36dc9860ad91dc64cec20b968c3b07fcb324f2f6ee42351a65c6b2156f8c10"
    sha256 cellar: :any_skip_relocation, monterey:       "fff77fa6473b8125bcb81169830f618b401219eb5af716be19b0641218333ac1"
    sha256 cellar: :any_skip_relocation, big_sur:        "fff77fa6473b8125bcb81169830f618b401219eb5af716be19b0641218333ac1"
    sha256 cellar: :any_skip_relocation, catalina:       "fff77fa6473b8125bcb81169830f618b401219eb5af716be19b0641218333ac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cf7b6950462af1f77ed4d1a9d5f3224a3d135babb0f3f93a0cc940e64369b40"
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

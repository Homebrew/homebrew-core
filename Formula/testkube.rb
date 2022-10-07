class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.6.5.tar.gz"
  sha256 "b2f2695a0059ad9dfed4c08637a2bd81aa9788b7a20dadc8b5de1ca1af4f9b08"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6e0900244520bff4a45ea0973d43c88b98f3b2f22b50e73bbcae8a6f7cce8d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6e0900244520bff4a45ea0973d43c88b98f3b2f22b50e73bbcae8a6f7cce8d8"
    sha256 cellar: :any_skip_relocation, monterey:       "126982d51e67660005934eef57193a6fdfc3f69c3055225b9042d69cecdd8a27"
    sha256 cellar: :any_skip_relocation, big_sur:        "126982d51e67660005934eef57193a6fdfc3f69c3055225b9042d69cecdd8a27"
    sha256 cellar: :any_skip_relocation, catalina:       "126982d51e67660005934eef57193a6fdfc3f69c3055225b9042d69cecdd8a27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51f0289cb889ed63880d21be54fe63bf07ce38b5eb6892091444606967bfbbb4"
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

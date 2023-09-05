class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.14.3.tar.gz"
  sha256 "a206e15067aee66006f0daff84c39516c312d9e6d14231154bf076590737b352"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a0482443f26d19c6bbdd6bc6be5e6dfff6092024fe0ad3dc9c6965d153e624d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9a532ea47e76576bcc4fde8745a3cb9028d83552e316f0fc9fa7b5d335dceca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09e7a8bb00592ea3add51144ec1d1caa2e064d13b28da7d433bac4a9b248e5b5"
    sha256 cellar: :any_skip_relocation, ventura:        "ce97f31581722b6c8558580ad052c6997abbb7277c0a023a545491544bc2f8f5"
    sha256 cellar: :any_skip_relocation, monterey:       "2e74dea26ad53b3ac2ac5a98244428feae74b67c5a27901f603ca51b5e20a513"
    sha256 cellar: :any_skip_relocation, big_sur:        "14ce0d3f6a548bb0378964534c2d9620a1b487c5db68072024634081655a873e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d7edc9b15904a4b66679b5c05674c3b05aceb4cc38236040fc056492fe26fe9"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
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
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end

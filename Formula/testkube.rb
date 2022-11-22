class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.7.10.tar.gz"
  sha256 "bf94c581b2d252b9114ece0943c2a3e12527815e82b6811e2858bcfa1156c6fc"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d0a564b1ee4482927be2e66d78ab0bdceca0494914e29e17c0f920c1f943365"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d0a564b1ee4482927be2e66d78ab0bdceca0494914e29e17c0f920c1f943365"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d0a564b1ee4482927be2e66d78ab0bdceca0494914e29e17c0f920c1f943365"
    sha256 cellar: :any_skip_relocation, monterey:       "6944791b535681d32113cf9147bede5e93eba60f4cc3d2239771b9e9cb7a0a06"
    sha256 cellar: :any_skip_relocation, big_sur:        "6944791b535681d32113cf9147bede5e93eba60f4cc3d2239771b9e9cb7a0a06"
    sha256 cellar: :any_skip_relocation, catalina:       "6944791b535681d32113cf9147bede5e93eba60f4cc3d2239771b9e9cb7a0a06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f0f378ac0aaabb759041656d49eb00171a11bcce141036a6f40b1016ea1a8fd"
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

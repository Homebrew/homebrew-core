class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.17.29.tar.gz"
  sha256 "a531256ad53ff8827674bee063a2cc4176193f2ac2639b1661a724305f37499a"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c9b033df58eff462e432bb9b9052502d0f37d4fa8ca3bfb93314195816409f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04e98d5855e91ed2993bac368d76fd71071c791fb1348241d87f9d880c3a22ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3288e8bc144d4e90d7c5267b4ab84cce16ae15bf5cf2281b352ad02f93c629c"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf5aeeb0728578ca8ccfcfa3736ddb7008bedc883b7da1f5c75d63cdc1f47843"
    sha256 cellar: :any_skip_relocation, ventura:        "d91bafdf2189a6ab6ba1eba266bca0bfbfd37906b4fe75790da6d9a0985e4153"
    sha256 cellar: :any_skip_relocation, monterey:       "f7dc8109ac83f2d69d0a4d93d0da8b485afdec754b667217d4ed6e8f7f82e581"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bf5b4b982439100fb27353264f875aeee7c197e89e04ccb869549c2556326a4"
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

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags:),
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

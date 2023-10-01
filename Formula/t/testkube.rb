class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.14.5.tar.gz"
  sha256 "433575fd6796b6ad8cd46acd1b8e7b2cfe91195cd3d66d6e746d8244cd331de3"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "435b3f6679b122ab05f8f749a69229e16923f3d6515573b3fe928b1dc91701f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9e2b2add3d8ddbc1163a41ecbc34a345c24dc3ef6ba4792984ce023a7cd751b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40fa84c746dfc5e58b0be4a7d8ceef45e33468843ac972c3a7bc61dbd8d62d41"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a8a2558f7e55dea05d3dc9c993665bf3fca995320d9f34f6eb253e9aa72d29e"
    sha256 cellar: :any_skip_relocation, ventura:        "03af3daeaf766a612b76a334ca3065879136d00574072c866d944b3264efa572"
    sha256 cellar: :any_skip_relocation, monterey:       "d3fb89bb0ff994d8d70a49fb35cc7c3a497f14971fb7c75982359aced8e26eb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "472d0831568b7871681636bd9241e4350b3d9cd772ad3b0ec8d4dbd8a6373153"
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

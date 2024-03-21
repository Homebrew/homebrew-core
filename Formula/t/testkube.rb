class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.17.6.tar.gz"
  sha256 "c4718f1044c6dfb888de1bc36749173acf2219518d36e1b417f8b0ae8595949d"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2b6e312ae5482b4bca9e78a98d568e764edd88bf3a935a25f847bae1cd18f95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd9649d1bb1b95ea7ec1f5266e3567eb26f9e90929f6a5a42524ab7cb67efd14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c97c6ff6d48ce26e4d06b94470fe3d4632e4abecbeeab2aa4ceaaf6f6d7423e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8a33a317fb7f45462fa4c6519c6ba78895311a9a6e014e527e269b52a4f5c21"
    sha256 cellar: :any_skip_relocation, ventura:        "98e42ca5524b7c7797b222dfc2b225a36b02947c9d954da1538e38ea8fba97d5"
    sha256 cellar: :any_skip_relocation, monterey:       "8e08d6d6b8b5f299dbd9add24932798577762a5317cee8b04f411d60d6d730fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2b902a0cf91ba33bbd3cbd518e97780cac7e94f8c962688ff16fe3022554803"
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

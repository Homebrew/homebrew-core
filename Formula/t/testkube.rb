class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.14.6.tar.gz"
  sha256 "96c7eb87c26225d299c733b4b9a3261cb87c6888fad859d96e9545ca629beb2e"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8369096845ccf75992190e517eaead0b474629ef6d3260f3a5ff0e174b58343a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0654ece864b02784391d85f7338c815f969d770d5fbe718b68f892c7bda6d5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "484bc255b31960cd88a8c58143e517f5022c80b800bd78e2daff888a019887d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f143b67b680aee18da07724ba00e1770392194e98c52b72f15eac392cd01cc4"
    sha256 cellar: :any_skip_relocation, ventura:        "1a284086e5b87c8bf66a771d0b616fb5f167985191f74144eeb4c809858e7e9d"
    sha256 cellar: :any_skip_relocation, monterey:       "1cc6d55c725df2f588744d46eba6046c5b09941124edc7b4a2eb82f7aa7322ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd2ea8d8f043eba256f6275ee17fe74296b5cf14acf05f81a949d91823a4ff9e"
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

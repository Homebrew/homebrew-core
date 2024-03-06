class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.16.34.tar.gz"
  sha256 "a06aa9985daa86c05c74fec7328dad9b3922411a31ac6720e8f8df10239d09bb"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc2c4020dac812f77d0e66c733931bab1f5448ada308ea72eefe698a466b5167"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b7e2e2c5018518943311c744e33ca3105cd86c141389944b65b5b3330fc8b9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb6cc0a4ea1fd195819d73b2892a9bd6b27775dc10f4bc5a3a4114616d81fe29"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca8b203a3b6cb2539e97cb8af9ab981e463855d53ef36a913ab570a4f75c3eb2"
    sha256 cellar: :any_skip_relocation, ventura:        "b0ef8426d5cdb1c5ca93ac688af0324fcde16834e8e8c43f7f67ee5c3a69d7ea"
    sha256 cellar: :any_skip_relocation, monterey:       "48c06aaa0ccaa65eac9ade7bc23b8306efefead5dc9b4ac0ed52e816678153ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c4747affef58be31317889b911df77fee029b5dc082fdca7ae731ef1d05a742"
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

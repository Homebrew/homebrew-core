class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/2.8.3.tar.gz"
  sha256 "782cece46af602fb5f17f7707e6e117b1752b33ba550c53b7bb7b364bbe30681"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "074beefa9f236e22dbc6e4a597cec5325881a908dfd08befc08bb0c0f1f8d906"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee6035563cde79b3bcb2b9210ed204a4c0240bb01e2777d97090d27b5551aa1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a45f5279a2ad65cd3605e6be07791813e8685121b63370fdd0a9f9c9d9869934"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f07988ead35de2e6d75ed6fcbd23ec0b73c2ea38b33fc083d145240491f5ac5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55355e09ef2d6213e885164673dcc1372802fd208c4bc71b446f83565594acdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "433b88b948400c509ed6a94849489923717cc75300ae7bc7aa3629005848b123"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get testworkflow 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end

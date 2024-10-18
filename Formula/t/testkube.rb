class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.43.tar.gz"
  sha256 "873b6d5595fd970b85377239065f2dfc7e3795ccc32d6602f61079dda798320e"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69a727e8f82d1f2abf296e2556e629230bb1539702a18b14287697a03a24c10e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69a727e8f82d1f2abf296e2556e629230bb1539702a18b14287697a03a24c10e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "69a727e8f82d1f2abf296e2556e629230bb1539702a18b14287697a03a24c10e"
    sha256 cellar: :any_skip_relocation, sonoma:        "297964b5c369993a2aaecd99a46c5bd056ee2a691c57f67616ac9336e7866720"
    sha256 cellar: :any_skip_relocation, ventura:       "297964b5c369993a2aaecd99a46c5bd056ee2a691c57f67616ac9336e7866720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ea10365c07d1a282995b65a9f1ebe0d61b525f83f821e5bb60098495cb49fe6"
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

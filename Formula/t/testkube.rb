class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.88.tar.gz"
  sha256 "d391ec29b939ec0e5f8add74b7bac2afa523316813756f5068c86549f072c835"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18a2502534fecc5145db5fd37ba345d7163bf820975b130073103246c3d4ab34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18a2502534fecc5145db5fd37ba345d7163bf820975b130073103246c3d4ab34"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18a2502534fecc5145db5fd37ba345d7163bf820975b130073103246c3d4ab34"
    sha256 cellar: :any_skip_relocation, sonoma:        "a72011a22fb1c6c7c72ca7fd09e740e806813252101f5b58d135b87f105b6968"
    sha256 cellar: :any_skip_relocation, ventura:       "a72011a22fb1c6c7c72ca7fd09e740e806813252101f5b58d135b87f105b6968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "045163ddf7379223559450de6e62789164e67a0b1287f7cf9a61f1d3809ee9e6"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
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

class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/2.7.2.tar.gz"
  sha256 "d6f9705eea644dc6b69d29a64e58d5e56fab5277775d9ec40f2314142c18191f"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "250f6a93ee3223d1ddb7ce8d3b1b7a1e205d92a5893b12432bcfea633a338085"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef3c5475a67ffa554264774f64c106762decbb88ca78e7e116e6fd69b5491333"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6745cfa07831ead0ae1227974deca00aab900ff2802094ec1d92425160eaebd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdb86b7913b00faa35bc1477d2b67db794b9c6e018d9a7db6c6f23dd5317f1c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a135ab80004202014cce14f3b12ec411876f51d7189808e4c92ea834c0a647c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d48fd1fe3897c729231f32645fa96afbacf48eec7bcbc8c02735201ebc4d80e8"
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

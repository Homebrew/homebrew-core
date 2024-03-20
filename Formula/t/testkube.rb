class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.17.5.tar.gz"
  sha256 "f87b31d12e38865d11a0d7fbc61dead9c9fae5175bb1b066337ce8bd9373e198"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae0056c0930a59309fe0190de06c9b69cf7b4b402a3db963759775a4804c7604"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ced068f684053201d050d4f856c6e693fd9d79c47f0dd3aa4b371f23e7f0d5b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a9f353af70ff513ec429a48810c0744d300e7652fec0062727352dd45c8ffe7"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ed53d0568fa688a8647c9cc514bcdbe5d16d3e74e863a498164e2b8d8f0166c"
    sha256 cellar: :any_skip_relocation, ventura:        "c4e7f519db83be94f3856b92b312ad47bddb9398f67320197e5af427c7133a60"
    sha256 cellar: :any_skip_relocation, monterey:       "7ee6064770f86a216e8e9e6c31ee8ca215a000e5a76fb27fc75b69115d77bfec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "accbf76a27b47cbb115cfe584d7e837679589a5a1b5f45dd5618cf546e2510b0"
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

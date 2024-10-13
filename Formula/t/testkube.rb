class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.37.tar.gz"
  sha256 "f46f2cfc6f4dc38bbf0b7d459096ac3d91ec56bb2e66a8221fd4f05ac4359b67"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d49f97d0783726dc5381a5af0d2ac9899b2546b5e802e26668590797df82d9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d49f97d0783726dc5381a5af0d2ac9899b2546b5e802e26668590797df82d9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d49f97d0783726dc5381a5af0d2ac9899b2546b5e802e26668590797df82d9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2a033e37012b4b9090f2eee0e92e9cfc05a2e96399a01418b8ec36fa59e59c7"
    sha256 cellar: :any_skip_relocation, ventura:       "a2a033e37012b4b9090f2eee0e92e9cfc05a2e96399a01418b8ec36fa59e59c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3684d2f693b159009ac648fbe7a6737fab04cf34f054b5ea171ec499c54d7d7"
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

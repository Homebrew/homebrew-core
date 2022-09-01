class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # TODO: Merge addition to `throttled_formulae` when version is a multiple of 5.
  # https://github.com/Homebrew/homebrew-core/pull/109371
  url "https://github.com/kubeshop/testkube/archive/v1.5.9.tar.gz"
  sha256 "0580b7c3eb454928784623638c68ddb211662e5623e5c97b95b99be13f36d793"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b58057ec51658861cb717bd38a192624fd1a979fd6eee3b21beb99607cdd2a82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b58057ec51658861cb717bd38a192624fd1a979fd6eee3b21beb99607cdd2a82"
    sha256 cellar: :any_skip_relocation, monterey:       "847e69b733987bc8227105e1ca6e0756dab9cb65ac1bd8502dd86c658cdb8ee8"
    sha256 cellar: :any_skip_relocation, big_sur:        "847e69b733987bc8227105e1ca6e0756dab9cb65ac1bd8502dd86c658cdb8ee8"
    sha256 cellar: :any_skip_relocation, catalina:       "847e69b733987bc8227105e1ca6e0756dab9cb65ac1bd8502dd86c658cdb8ee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5a5d7ba42b118976e798270ebb9ab3e5325a29f3d132744d5f44d975014cc1e"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags: ldflags),
      "cmd/kubectl-testkube/main.go"
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("error: invalid configuration: no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end

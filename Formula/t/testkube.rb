class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.17.22.tar.gz"
  sha256 "dfbd37b128ff7ec51f5372ba4b04cfacd9005373e49e8eaee4754fa8811cd937"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1dff7d7754fc3a830ba76b1c42f78480830555f04def4c43688e7c3389d7773"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8256e1b57d0f4037fb6d81bc291237293ddba69ab3c0d0a6f241e7bdbdd14e00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1f9148dbefd1de1f61d487e1337ca2a507c4b63e4ab995b6aeb816c15f172cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "45f280cdfe02f993a60f18dc0fcb452c2827c65506d10dca0a938ea32ad7ab0a"
    sha256 cellar: :any_skip_relocation, ventura:        "a154dbfa8cefc4ffc1be9449041118cc396db034e42d64ac76b4dcaf4f3efa1d"
    sha256 cellar: :any_skip_relocation, monterey:       "1e051ac7471e4497f38ba52561838f1aad4bad39d46df2c2c1cee8d49d2d9e5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f1ae76551b2dc46f4635bf08bd1fe48dade52b9fbe59a3b9230db03a2423932"
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

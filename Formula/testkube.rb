class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.7.0.tar.gz"
  sha256 "0675dab13af2d5e1900af112251a8c298a5b81df62afa74bb711c489b4658733"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f84a98780da65f928579b6df287a0dd04acd876d29f9725daca234efa2f7cabc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f84a98780da65f928579b6df287a0dd04acd876d29f9725daca234efa2f7cabc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f84a98780da65f928579b6df287a0dd04acd876d29f9725daca234efa2f7cabc"
    sha256 cellar: :any_skip_relocation, monterey:       "e5fc637ee55c14cb936af5c6765e37719722332260711311973ed130e61e29c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5fc637ee55c14cb936af5c6765e37719722332260711311973ed130e61e29c5"
    sha256 cellar: :any_skip_relocation, catalina:       "e5fc637ee55c14cb936af5c6765e37719722332260711311973ed130e61e29c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27128955b07bc27a8d53885e50992f015571addc7b27340d6ff88123f283478c"
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

    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("error: invalid configuration: no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end

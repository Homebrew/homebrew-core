class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.33.tar.gz"
  sha256 "a1ef224e1744116db805992c2108f9de25fb0518bbb8ec84f470c576c881320d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5aa47f38599230b737e0a2b46c177f72e5f5300b4fd78495426abeafcba91b9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5aa47f38599230b737e0a2b46c177f72e5f5300b4fd78495426abeafcba91b9f"
    sha256 cellar: :any_skip_relocation, monterey:       "6e13bc153b8bfed3e0bdb0466cf0a2bc5936ebdb21cf233cd9aff76e0860b4cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e13bc153b8bfed3e0bdb0466cf0a2bc5936ebdb21cf233cd9aff76e0860b4cb"
    sha256 cellar: :any_skip_relocation, catalina:       "6e13bc153b8bfed3e0bdb0466cf0a2bc5936ebdb21cf233cd9aff76e0860b4cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01536b6b35fbba54b9b83b336a9d7230f63a6c7d9fdefc299c2bac8fb627e302"
  end

  depends_on "go" => :build

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

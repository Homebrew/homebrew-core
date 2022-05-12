class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "a630584cd4588373a5f96f29426f3c6b14fbebb36127fb34514b8954a07346a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eed3a7f981d37a9dc52b8a8d8c8ed3a1c2c3c0c67b98265a7072ab88fd5a7a0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eed3a7f981d37a9dc52b8a8d8c8ed3a1c2c3c0c67b98265a7072ab88fd5a7a0b"
    sha256 cellar: :any_skip_relocation, monterey:       "0c1ec27e701e6893eecd23465cb43348cd8bc333c0dfc52afc0487813c9a548d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c1ec27e701e6893eecd23465cb43348cd8bc333c0dfc52afc0487813c9a548d"
    sha256 cellar: :any_skip_relocation, catalina:       "0c1ec27e701e6893eecd23465cb43348cd8bc333c0dfc52afc0487813c9a548d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f2d852c238ca7eb446682b1e9a58fb1bd5db82b119d9eab0f9a19a99235dd7b"
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

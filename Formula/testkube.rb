class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.13.tar.gz"
  sha256 "a4ec77b4066ba874edb164fb5ce8c0642c4053c379d2cd06e8a03069cc871864"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "376ca588a4fa9125c5c64ceefc3471a9d0421c412d17acf9636b46e43ff9eeae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "376ca588a4fa9125c5c64ceefc3471a9d0421c412d17acf9636b46e43ff9eeae"
    sha256 cellar: :any_skip_relocation, monterey:       "8de6de71eceb3bd1c62aeee50f956a22bcb02c7146b62cb008db66a825ea288a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8de6de71eceb3bd1c62aeee50f956a22bcb02c7146b62cb008db66a825ea288a"
    sha256 cellar: :any_skip_relocation, catalina:       "8de6de71eceb3bd1c62aeee50f956a22bcb02c7146b62cb008db66a825ea288a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7859c3649d8dec454d5ab2f8ce1f8366e0ab8284c3cd37edf515768a6b29bab6"
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

class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.10.15.tar.gz"
  sha256 "f79d64e3ded270f4d012dc4d9be828dd1669d6724e1f2ebe7cfa7a0c923df657"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "448786c41040a7a20212183f969c578ddb776dfef7311c1666e2691c32adc3b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "448786c41040a7a20212183f969c578ddb776dfef7311c1666e2691c32adc3b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "448786c41040a7a20212183f969c578ddb776dfef7311c1666e2691c32adc3b1"
    sha256 cellar: :any_skip_relocation, ventura:        "c9981f98b579abe4c489fe7e5b47b53ebc104d019ff390d8ea1e5a16b6719cae"
    sha256 cellar: :any_skip_relocation, monterey:       "dbed0cf681ee7545a3081d190efb48c1ca8cd07017a86203981f6db75b128e53"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9981f98b579abe4c489fe7e5b47b53ebc104d019ff390d8ea1e5a16b6719cae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "500a6ba7ff2e18401769f56be871f504a89992d1c604d2a8250a18ac29b6fc64"
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
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end

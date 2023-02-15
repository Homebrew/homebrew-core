class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.9.10.tar.gz"
  sha256 "357844cc0b8dea0dcf94b73da5f73c377042cc54a84775b33da65848c690f29b"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f06d8c1307da6faf4cd86274bd554a39db8108f4d87bca13e8ff65a2c53b4dfe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f06d8c1307da6faf4cd86274bd554a39db8108f4d87bca13e8ff65a2c53b4dfe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f06d8c1307da6faf4cd86274bd554a39db8108f4d87bca13e8ff65a2c53b4dfe"
    sha256 cellar: :any_skip_relocation, ventura:        "a83c99731af5c4e4613e356fb139309af053cd5fa943488f5af72f1328bf2921"
    sha256 cellar: :any_skip_relocation, monterey:       "a83c99731af5c4e4613e356fb139309af053cd5fa943488f5af72f1328bf2921"
    sha256 cellar: :any_skip_relocation, big_sur:        "a83c99731af5c4e4613e356fb139309af053cd5fa943488f5af72f1328bf2921"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c98b18baf215b8d6f111f3b06a8bcd0c549a3ba48e91ab031defe23c0bca84ab"
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

class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.15.10.tar.gz"
  sha256 "7ce3b62812434d25612f6a0b189c8c8ca4df3d16fcbb7c97e0123d5369a6d3d5"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "045e6a0873979775f10757882ec608a7d908ab18b5ac122ad06b24b55f0d2148"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c567343ac516a5706eef78197f41bf0368f8dbfde2ac1c7fd397a4ce6c9e0adf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dec0de5fa754aa1726b76f54c28c692305c0f8c4fb13d35bc228699268bbda56"
    sha256 cellar: :any_skip_relocation, sonoma:         "180b9a0de783150370f5b4413ee65b8cbec2584b159a11c3a02efbe5656b4549"
    sha256 cellar: :any_skip_relocation, ventura:        "6255dca2d7cfc5143a41a75a7c0e3057a372a0408833b7e416d13113cd03a76e"
    sha256 cellar: :any_skip_relocation, monterey:       "99b91192411169a7bd8d0f03283560a5a669c3b3284a368c87df0eadf76cbbbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16b0ce978e6786b60ee714bae632e26c401b011b5b44b0e008d69a29060a1c76"
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

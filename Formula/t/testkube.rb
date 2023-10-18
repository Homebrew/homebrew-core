class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.15.0.tar.gz"
  sha256 "764fc8ea0dfce42f7c956eea0ddf70c763d3958640993183f754970baa0010b5"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddfffc79a54b85dc0942ad715dc58bc859954c7b8e2b2b7cb0374787daca9b1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68fadb7f3f2b577df45ed922175e7ab22a74d28971c1eb459ada0c89ed5088f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d787de37139d443916c3589f8046278693eec34169a5ec7b81b0826d62f4e76"
    sha256 cellar: :any_skip_relocation, sonoma:         "918b49a32f18ee2f56b743a4a8751106aff97ff644a64f7b6a12c0b07835929c"
    sha256 cellar: :any_skip_relocation, ventura:        "5e6ce1ca116775391c0448776bc58074efda0e9326a36525038b89030a1b7553"
    sha256 cellar: :any_skip_relocation, monterey:       "ae21d2ebb19a2c56c7a33be37e4c64574c9ec21b6ff8c7f35cccd60d1f9af416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc479c77c3fd5b8fcf276a548c5f1f38827ab98b5fc9da508d1430ef9fde8fcc"
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

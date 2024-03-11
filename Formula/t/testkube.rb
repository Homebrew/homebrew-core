class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.16.36.tar.gz"
  sha256 "0acf06405b5110e0f31f5d0475cf7c8022328deb00ed07ef7fb4c3f91b947184"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fee4a6f7de7c03fd731bec8929069502db80e1237cfb7281a5129f2f22c5c5cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9881c3775c4a70f24a5dd3bea6de10c4ac511cbb8af1387a119841ea8c704ca9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb7e749451a923b317bfb4c41322d05358e23d3a3f8035ec34680ed4ba387d06"
    sha256 cellar: :any_skip_relocation, sonoma:         "45ad0b4c7d1088abb4e72ac1f57cff47b4572edf2c3bd25645dc98599d69a41e"
    sha256 cellar: :any_skip_relocation, ventura:        "398c3e66fda1328095b83ef86f2429275ed5e4b9ee15be8c640f8b7982f50a33"
    sha256 cellar: :any_skip_relocation, monterey:       "9955c7585eb49f53f13cd6c003344d492430c5aaf63f19baf5b361ff2b3b867b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bde8a4a44176d65668ce40fd5aa9168376a6f1b7c6d6dba69516e07dbbc6b31d"
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

class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.14.2.tar.gz"
  sha256 "3b38965c9840601af391f92eeec23d2a9c5da03995f237c220a392f98c51759c"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efaa7542c9c890a0ef8b73a0d4a4e70dbeea9f6484b31505b64d30ea9658b92e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7b9640c47c6460b0a6dc7422a6f2db09acfb36db770a8d74205dbead3cee123"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a899ad40f8bfa07ef7e2eb7a0fc61556a8b2af04022ba09ff6856f49c357164"
    sha256 cellar: :any_skip_relocation, ventura:        "c74b5dcdb3fba113cfba9c0f9c53248cf8f55ef444d766261f90b647af45625a"
    sha256 cellar: :any_skip_relocation, monterey:       "3efb8c5ef2cdf6fb073e70a88343a26f10c672641f59a5b74e56af0c67c9d1cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "923852d6e623d88d6f89d79f4ebfe12b140dc0b2f26856259245a97e87260167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "545180c52523fca363770f90cd8ed3d134973a1a312f1a6e6130f3a3074d1365"
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

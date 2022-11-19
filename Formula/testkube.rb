class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.7.5.tar.gz"
  sha256 "32303b03194e02812d22c30b3cee3868cf77be9a791b2a6553362637670da71e"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b14abf2654beb3c6b83c913309a64735993fcd572aae917f63aeacde2fdd3d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b14abf2654beb3c6b83c913309a64735993fcd572aae917f63aeacde2fdd3d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b14abf2654beb3c6b83c913309a64735993fcd572aae917f63aeacde2fdd3d5"
    sha256 cellar: :any_skip_relocation, ventura:        "c88a534fce057b5bb7aa4e11ebf4dbbfd610124bd0f4eeaa8fc76d05646e8103"
    sha256 cellar: :any_skip_relocation, monterey:       "c88a534fce057b5bb7aa4e11ebf4dbbfd610124bd0f4eeaa8fc76d05646e8103"
    sha256 cellar: :any_skip_relocation, big_sur:        "c88a534fce057b5bb7aa4e11ebf4dbbfd610124bd0f4eeaa8fc76d05646e8103"
    sha256 cellar: :any_skip_relocation, catalina:       "c88a534fce057b5bb7aa4e11ebf4dbbfd610124bd0f4eeaa8fc76d05646e8103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f4e8f90f96563a00696b508e549ea2ec97b3f864eaeeecee05dbbad98b89a1b"
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

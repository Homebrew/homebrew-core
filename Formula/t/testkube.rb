class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "cbbd3df89f5bd9a8deca678c59ef309e52acf2e40645ec7ec48d86c2021b295a"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4cd54fa7284d4c0b5821cc03f4191a9ea58ca5b26ee8693ded6605ea21797e2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cd62246bf06fa685686cde360d35e7e230dd1258aa7166dbe6bbede2e843b52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8753b40d5c0e102c87e406d1ac07660084c1d279469fe1a5f83ab341066bfb2"
    sha256 cellar: :any_skip_relocation, sonoma:         "a04e4bcc278dee9297ce94a72e86f35e25145b56afa946ca6faa6b347ed62cd6"
    sha256 cellar: :any_skip_relocation, ventura:        "05b7ae6a0b6f69ad8d738072463543fdc70d9989ee0ce75dc2e1b4584abdb4b0"
    sha256 cellar: :any_skip_relocation, monterey:       "279546358b7fd53df25629028cbbee682b13ad01a6d59cb16bc9b205f554cd09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afa569fe3e9177ceaa0206401513019cc6cebc109a2ac40346c6938c0205e231"
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

class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.6.30.tar.gz"
  sha256 "83e61896cbc228a4e89e31375b43d801aa58a7f7366d986b5aedb79655f1c53d"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d9e0492f398c84641a4e650f52fac9b1cc293654fba8b60b95db5a2f4bf149e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d9e0492f398c84641a4e650f52fac9b1cc293654fba8b60b95db5a2f4bf149e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d9e0492f398c84641a4e650f52fac9b1cc293654fba8b60b95db5a2f4bf149e"
    sha256 cellar: :any_skip_relocation, monterey:       "8c9a74beb72b8d1d48b6516622401d2eeef6a1e3c2e30cf864e9ea39fc41707e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c9a74beb72b8d1d48b6516622401d2eeef6a1e3c2e30cf864e9ea39fc41707e"
    sha256 cellar: :any_skip_relocation, catalina:       "8c9a74beb72b8d1d48b6516622401d2eeef6a1e3c2e30cf864e9ea39fc41707e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15253820a84138f571a40537991f794d670d6ac209c07a12a134ca69508d0e28"
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

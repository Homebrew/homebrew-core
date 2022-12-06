class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.7.25.tar.gz"
  sha256 "a334f311f5dad39c63faec7aec5e27f786cbd637f2ed43bd71052a1f08539c4c"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8647dfb4a6f696a4f96559d250765bcdcd791a72cca5f5b43fdb53850a92d774"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8647dfb4a6f696a4f96559d250765bcdcd791a72cca5f5b43fdb53850a92d774"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8647dfb4a6f696a4f96559d250765bcdcd791a72cca5f5b43fdb53850a92d774"
    sha256 cellar: :any_skip_relocation, ventura:        "513363b62dd2717a5a920125edfa7b029be0fd9a64e26ab6198203f98d869f93"
    sha256 cellar: :any_skip_relocation, monterey:       "513363b62dd2717a5a920125edfa7b029be0fd9a64e26ab6198203f98d869f93"
    sha256 cellar: :any_skip_relocation, big_sur:        "513363b62dd2717a5a920125edfa7b029be0fd9a64e26ab6198203f98d869f93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89bc3064f985649ac49893b9fc44c3f24bcd1b5cce7048bd104244d29d9bb129"
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

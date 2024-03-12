class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.16.39.tar.gz"
  sha256 "a3e8dc6807e112f265932a405be88030bd92e7a283f54c5255615082de18c543"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3e2ad19412d472ab3c4c685dc8426259ade9e7ce50c7495101c64ed23b3f030"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b15c69bd7de639f8815ca67d1d9d7b5b4120e165f95e78e518cc6c884e31fa5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f22ca5091036a7548d5303fd6c3421bc33c09aff7c850912cadfb61872732345"
    sha256 cellar: :any_skip_relocation, sonoma:         "43e75b442aee7bf646ba65e25eb61ea77ff80fa1b2c2cc86ea155d912b45a60c"
    sha256 cellar: :any_skip_relocation, ventura:        "b958204da971142b5c95ada76bc8e2393a78e6b383567df16791f4bdcd49668e"
    sha256 cellar: :any_skip_relocation, monterey:       "96e13c50c9449747a51aa1443f324d5ff6982d276ce4286655bcecdd800cbcbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7f84a6568f83ba94864cc6ee09f8ab0b55d59b2fa8f4d32c0b332b096de7a38"
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

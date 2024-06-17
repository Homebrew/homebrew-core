class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.17.63.tar.gz"
  sha256 "8870e2bb9df6bcff4c85066f1b0f7c611bad69e754213b43254cde2410a11420"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34fa9aa8a4fb418e6454ee773d936f8e65d3aae38a4183668cee744f80ca7c15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26795f784ba673285eb5f4fe9b6338fcff10ae2cf39b3434d5818b39ef6f030c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "100f7f091c365d9c214d9bcdf0a3f56b1f66e3c512ce3d88dfa62865bb75b33e"
    sha256 cellar: :any_skip_relocation, sonoma:         "2bdb363a104b7ab136b90c43ac9cb2607df17d409acdb7e33d1a3d34138d2ea5"
    sha256 cellar: :any_skip_relocation, ventura:        "4143556ee1e994041da4149ead3579d898bd0ade4b1e3fd9214e15dd22f5e527"
    sha256 cellar: :any_skip_relocation, monterey:       "52ae5ccc8e92d1ec9dae1bd384a0bb6abc3fe9356ac870447afd84fee8fa61c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bc74b6539f8ed5dfa14d96378ed581bda85cd9018e523488674463d1ee01744"
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

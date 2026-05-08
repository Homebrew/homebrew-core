class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/2.9.3.tar.gz"
  sha256 "0618b6be885be9088935ccc55e16eddbd5f5486875b8210c9154f60aeeebaac3"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5014e05bcf44cd734f0c7e5683cdf51eae918893c463c6b391cbc87b7c98cd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05af6ac0280af81e114f0cc905bf32d1ccc49d2f7ac4bc619a3b825437ba5994"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdb6edeec49f684891efbd918b88a49f71dcdbfa936e0a6463a245b8821bfb93"
    sha256 cellar: :any_skip_relocation, sonoma:        "196897acce6aac6a4f09950008bf0f385438e3e4e2fc7a31175e52a99fbf63f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56bf420e33cb594f4064aad80aa8fb7d38cd31f0a21f05b1cc8af2574ddc4341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "407b5c8830738ba9f0ab1362042c3639af422fb041c5063bd21ecce1042e2ad6"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get testworkflow 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end

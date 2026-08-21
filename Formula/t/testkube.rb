class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/2.12.2.tar.gz"
  sha256 "7fccd113d17cc360d157dabcc8af112a71e4b4d0d15aa79f5c5b1fce0610e048"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dc8d7f7a0acc1faf3b476ac37402135b695af5e455b8d6021539fdc7f82a5cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d4027a0829dcf1f0e75095dfcdd5234655321cd91c6edc16d91a46b2486f12e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "249bffd695f1ffd00fd96c513d887efc18eeda65e42bb2b47cea121b7093e1ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "b430aba6da3d04ce95127cca60b421bea2f5e615a5528ade34b1a1fa5e78e816"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "754e2f9963f64830e46ff0a54fa89d246efec516439889c65f5bef206b3533db"
    sha256 cellar: :any,                 x86_64_linux:  "2cee44ab09d0f2494457db109976f72f91f58dfca31007836a7ce1856fc8b7ed"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-X main.version=#{version} -X main.builtBy=#{tap.user}"

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

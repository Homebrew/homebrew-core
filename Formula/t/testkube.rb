class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/2.9.4.tar.gz"
  sha256 "1588ed544184bcce75c7e168429aa350182d16292d709c14563781b16b8afe4d"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "458fbefaa829374deb21a5034e59432f29f65635d1a96ed1c634ec9185b4f5b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "857f6618fa6c99cefe7c2c8dd23f416386d2cf8cc47d1e9fcc4b79e081419f94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fd702eb04118342618220e693c4282a24de27274b6e094054d1095636f46020"
    sha256 cellar: :any_skip_relocation, sonoma:        "87c3c40d8adcfed85d2c239e1d5a58777cb0364dc2dcd763aa426bbf95ea7e93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fb92d3f550a8960d1e192da10362070a1827b26aefcfe2245ad47310cd027c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7dcf9c2cdb2d59aa8c2a27de7737e20c244f0f08dac0c837e3d0b292d5e8238"
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

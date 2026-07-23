class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/2.12.0.tar.gz"
  sha256 "db0557e2a93c4c52c4e1cce05b8c46815d37e47c8274d5a10fdcb2219dea6903"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "768ae8ca047f4c239876b04b13fa6c24d021a5728c932abcfa8dfff1f0f9e4ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20a742d33bc6b8072ed78beac82138c33f357cadfc5d891cc88476d59b97fa52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95a5004b879630c117a0ffdbd11a219b31230f541546d3ef41890bd408c0ad4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "633a5d47dcfe56be92f70fe982a0509c630d2b4bdc4a11d6a7f04ad46b0c23dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e24a442505bbd354a714bb55bb10a0290b44257ecba93b5031270c7390138f0d"
    sha256 cellar: :any,                 x86_64_linux:  "3bb71ccc92e4509b77f4428c439d3127956523fe0fefc4a1d2b742349dd521a2"
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

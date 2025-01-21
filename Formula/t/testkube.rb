class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.86.tar.gz"
  sha256 "4d5051f1a6f38529bb3412d1c4e0b016a17c30d3fc3f8f3096b46f663c53569c"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b668b1e8c67f6170fb95d4f9365b2bb856014838123d096439f013f2a33ac09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b668b1e8c67f6170fb95d4f9365b2bb856014838123d096439f013f2a33ac09"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b668b1e8c67f6170fb95d4f9365b2bb856014838123d096439f013f2a33ac09"
    sha256 cellar: :any_skip_relocation, sonoma:        "f355308344d603495eff39178e5a5e8660c4d043c70d4d0373c971b15c1b0ae9"
    sha256 cellar: :any_skip_relocation, ventura:       "f355308344d603495eff39178e5a5e8660c4d043c70d4d0373c971b15c1b0ae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e87a50ba34016cab323222a25b798df911f75a920e8ac3082b9559b981801c7"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
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

class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "54a936519598d52136e69b9cb523c963945ac4db8a6811f477b70dd005d7c26e"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "928ce94e9e343d80107e7088f17ad283ad7b072a6dc5d44cc622f5e93caf47bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "928ce94e9e343d80107e7088f17ad283ad7b072a6dc5d44cc622f5e93caf47bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "928ce94e9e343d80107e7088f17ad283ad7b072a6dc5d44cc622f5e93caf47bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "83650968582a3798e44373bc98ca5e93e19211a54e04946b62eac9aa041ff5e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20646e711890b076e8c2394cb352e59c9ea7f8a56bcc594196bd7f1e49a5e2f5"
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

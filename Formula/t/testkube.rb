class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.110.tar.gz"
  sha256 "ae87542caa2505f2b7a5b9048162b00a517d531709c43e3c5bf333456cd9336e"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19b3bf252b1b379d464c2e62c89db2d98ba74b203d1a1af37123625ac9b0fd7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19b3bf252b1b379d464c2e62c89db2d98ba74b203d1a1af37123625ac9b0fd7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19b3bf252b1b379d464c2e62c89db2d98ba74b203d1a1af37123625ac9b0fd7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce25d77d9ebe108fb56b7afaf07fc2fe6eec44da71e74f4ed44ee00568be52a9"
    sha256 cellar: :any_skip_relocation, ventura:       "ce25d77d9ebe108fb56b7afaf07fc2fe6eec44da71e74f4ed44ee00568be52a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed27672c0287e6ee22a4ea23e6cb4313b857d73daf96cf8dcdddcb1b23ef6c6b"
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

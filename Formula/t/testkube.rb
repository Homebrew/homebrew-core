class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.13.13.tar.gz"
  sha256 "bb4f5fde6d27b2e6265d91c50c3abccf1aa2eb06d8178b5c6bd70f2bed54ecf5"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6172c49f6d263f202a858831835f97626508a4d2caab387f3685a923521c4573"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6172c49f6d263f202a858831835f97626508a4d2caab387f3685a923521c4573"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6172c49f6d263f202a858831835f97626508a4d2caab387f3685a923521c4573"
    sha256 cellar: :any_skip_relocation, ventura:        "3978778b2b1509c7c6c81bedeb2c6881b3c12870b6c0796126e2d2c6f6c01f79"
    sha256 cellar: :any_skip_relocation, monterey:       "3978778b2b1509c7c6c81bedeb2c6881b3c12870b6c0796126e2d2c6f6c01f79"
    sha256 cellar: :any_skip_relocation, big_sur:        "3978778b2b1509c7c6c81bedeb2c6881b3c12870b6c0796126e2d2c6f6c01f79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f535015878bc624d19ba19e5ead2e5b3c3b80787f914679cac59e604b330aa64"
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

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags: ldflags),
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

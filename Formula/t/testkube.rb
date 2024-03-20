class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.17.4.tar.gz"
  sha256 "2dd131bf546794a583086062387c7fac71a18d5f8b28e7e0d1bbfda12aa36f4d"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fcb02046f2e44924e80cef809567d12c65117daf8ba0b5d08d0aad2e48173700"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d5484674143468522c5cdde588421e73b99007ca956188fe5ebcb7eb3d58ad4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e6a2607739bd0b76aa8b5ce08e7b763893b97954e007b961d1ae6e86b6c21f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f6cf2331101faf821b36218043c74620b022707066faee7d4e4bd4ee4256990"
    sha256 cellar: :any_skip_relocation, ventura:        "562d9cba795aa4bbba0fcbde7a4e0c61dc7a90a15b3299fe4091b6d4190d619e"
    sha256 cellar: :any_skip_relocation, monterey:       "668477805b6e3ca86ab5c4df217972759b958d288fe46e150a26d3ddb1bc43dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ff5086d3a1216b7c49584742a66d5cecb0dcf0429fbf0ec4d01879a8d1a9001"
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

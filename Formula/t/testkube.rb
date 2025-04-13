class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.140.tar.gz"
  sha256 "84273313daf28e71803a06653a44cfa7b4512222440708636cf3cfa260f8f304"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1206e1ffc0093a77de6764fb6b5067feeb2737e51ffccd6ba4c3684e98390eee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1206e1ffc0093a77de6764fb6b5067feeb2737e51ffccd6ba4c3684e98390eee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1206e1ffc0093a77de6764fb6b5067feeb2737e51ffccd6ba4c3684e98390eee"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2877e04a71127296d29035e65d3266c1f5d6d0e780e3ed49227989f0556f0df"
    sha256 cellar: :any_skip_relocation, ventura:       "c2877e04a71127296d29035e65d3266c1f5d6d0e780e3ed49227989f0556f0df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f4896ee9fcd369e8d402967a7a314ac2db6a2bc0cd439daee4e903b31381e42"
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

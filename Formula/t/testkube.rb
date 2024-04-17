class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.17.14.tar.gz"
  sha256 "7bf6760787470c2843887f521cf5a882fad22591f0453c1de44f64680cb2e7cd"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72fc0750eee6c7d57a25e92b2b58f58befb7fe6ca81f1bacd69f094972edb1cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a8f66ac4a7946c93a650438ad19dd81ddc6e5f9f5aade5b33f8917eddcaa906"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dd2e97ce195da2a9fbc7419d15794d853909df4a6e971a631c479ddcde32f67"
    sha256 cellar: :any_skip_relocation, sonoma:         "5504f8ae3d0a50e895b810d009b0e71635a5eb7c6cac7ff33bdd376ae165b3aa"
    sha256 cellar: :any_skip_relocation, ventura:        "4782b2ffcf248150c494d24e37154ee1fa083815d555e559bfe0a3c6cf21bd98"
    sha256 cellar: :any_skip_relocation, monterey:       "194fec8e6456a311395e4f77e227366175762b9e4f21879464c00312811d0fae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a539e6205e2d7cc76966cb3d4c1a394702d15492ca29f8175ae9516c71a74354"
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

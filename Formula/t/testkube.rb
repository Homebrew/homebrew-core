class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.17.51.tar.gz"
  sha256 "edfdc0a3eb08f5f222370bdce6d94162afd82733b9c77712694f5102a7bb3cde"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0bc76802d967ba91f658a9922e20aecd3da48e3e5347abc58f6a99b241bbb6e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27ead48b69fc772e097c2dc922eac48eab70fa0c33d1887867f76429e66cada5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff663a72499029bcfd799d6244b2f3a2b5e564546de80b99a8cc51649eef8f3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "77e29602f8faca9a0fdda3e53e20af8852262776deb79a23d8dee6c09d629cea"
    sha256 cellar: :any_skip_relocation, ventura:        "568cdfc5e0f696cf7a0fccb9dfd6eb0da91b6903fbc33d63b8030b62df4d2008"
    sha256 cellar: :any_skip_relocation, monterey:       "dd7f62ca07a1ac3b4b1b0e911aa75395e078c45027128d3ab914dde401e0db89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "836a8c5c06c431722b7234529db131c7eccd55785a1d53b7261b5a50e6ed1b4b"
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

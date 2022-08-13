class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.4.21.tar.gz"
  sha256 "6c79c6684027b56ac6b4fea3511f7cf9b0784fdc687eccfb6f4b904f54a5d79d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57a1eb2d3c68f49518dcbb5b8447562f46a985de8be2044d84659cea5321088f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57a1eb2d3c68f49518dcbb5b8447562f46a985de8be2044d84659cea5321088f"
    sha256 cellar: :any_skip_relocation, monterey:       "28314a7f4512dafad2850264d64fad1fab8a11de2e87183095b8efc92a0d310b"
    sha256 cellar: :any_skip_relocation, big_sur:        "28314a7f4512dafad2850264d64fad1fab8a11de2e87183095b8efc92a0d310b"
    sha256 cellar: :any_skip_relocation, catalina:       "28314a7f4512dafad2850264d64fad1fab8a11de2e87183095b8efc92a0d310b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ef51ba85ab2ce6e6ea8157788ebafa84bb8de8f83dd1202f0867eb368c42320"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags: ldflags),
      "cmd/kubectl-testkube/main.go"
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("error: invalid configuration: no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end

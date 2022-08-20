class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/v1.4.29.tar.gz"
  sha256 "9a924d623422830f1b1b2c92bba4222e19b3c32a0d4c5a98792b301e9de3a689"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0db4dbe5d2f0b3d4a6b1d6dd4ff2c195644129a66b57cfaef77118cffec7043"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0db4dbe5d2f0b3d4a6b1d6dd4ff2c195644129a66b57cfaef77118cffec7043"
    sha256 cellar: :any_skip_relocation, monterey:       "8e3b38ca054fd80370bfc6bb1976c2d22e5a41a3656e85d186ee4827a6037de8"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e3b38ca054fd80370bfc6bb1976c2d22e5a41a3656e85d186ee4827a6037de8"
    sha256 cellar: :any_skip_relocation, catalina:       "8e3b38ca054fd80370bfc6bb1976c2d22e5a41a3656e85d186ee4827a6037de8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07e99e0a9328fed6ce2e80294be21fe1a8ca3f5874125c2cc2f7acda350851b0"
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

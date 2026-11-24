class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/2.15.3.tar.gz"
  sha256 "36273a709be4c3b70db8a90f599c0b1496d648aa9e4fe985ef590ec85ac86606"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "f198dbd480ed5a22f4d97b8b14898251b5ab53619102c0d110fbf2cdf4f910b5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0e97962c0fdd8e673ad6bf2d8cfb47d4d8da9cc490fc19d2d9647b2d0db2fb64"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b89f492785fa2f353e9d4b89ae63bfc79ce09729f8d77b4e5c2228bd4de4e210"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d52096645a4957e609016283a1496368d4f6f5c3d145d6a42bb90ec5353c60cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0b0e83d4f6efb4d13910bd90bede349d9877093d4f3d4dbf2762ec484cea1e2c"
    sha256 cellar: :any,                 x86_64_linux:      "f3e21afc8ee546421a775e7bd6ab3c1e8d3bcee323ba721b466c4c57d79dc26f"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get testworkflow 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end

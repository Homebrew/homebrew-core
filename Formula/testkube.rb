class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.10.0.tar.gz"
  sha256 "e676cd83cd2208218d726927bf394bcb9b7b71f9fe566a7a953782b01c96d019"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72d6d8c3293bf958a5b28bd752d966b88b8042427dc022623344688f8d9b1952"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cb8dde8d78fcf5e0a81485df6748d1aebda6e9785a597b063cc7875a680aca1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72d6d8c3293bf958a5b28bd752d966b88b8042427dc022623344688f8d9b1952"
    sha256 cellar: :any_skip_relocation, ventura:        "5b86bcbb8a52a3ebb1b1620cb60a85b9c65d7583ca9563175a9a663192fd533a"
    sha256 cellar: :any_skip_relocation, monterey:       "5b86bcbb8a52a3ebb1b1620cb60a85b9c65d7583ca9563175a9a663192fd533a"
    sha256 cellar: :any_skip_relocation, big_sur:        "957cd19a7d97dce656e42d80fcfff89c2dc166f66e2adc56245be6058075e3ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8e943c9d4fd0ef78d27f450c86d6710d2ee608b7686f4ec21d8aa7b119301f8"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
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

class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.12.10.tar.gz"
  sha256 "85c5120d2103b9327df991abbf664b1b084834947798f4ada591907f9be4d2ff"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a28275e52641baea050b2762232c4dda374f88880c06cdf69b9c1e01722087f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a28275e52641baea050b2762232c4dda374f88880c06cdf69b9c1e01722087f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a28275e52641baea050b2762232c4dda374f88880c06cdf69b9c1e01722087f"
    sha256 cellar: :any_skip_relocation, ventura:        "65dfec9ceab6db8f5ba45b47dec1174ebb169ca38c46bca21db688f6657ab4bf"
    sha256 cellar: :any_skip_relocation, monterey:       "65dfec9ceab6db8f5ba45b47dec1174ebb169ca38c46bca21db688f6657ab4bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "65dfec9ceab6db8f5ba45b47dec1174ebb169ca38c46bca21db688f6657ab4bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2742dc69d93a958aca45221c57228d44a4fbe96557b13e039bee4513452e8e24"
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

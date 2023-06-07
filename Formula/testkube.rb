class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.12.0.tar.gz"
  sha256 "22988e338cea0b243ca6df641e2acf4d5dc6fecd7070dde6e851bf07dc3a16b2"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95cd45bb9e3a2fe66b14a2ed06ae99ece75b6bd33222a9c5ee790a38c6226b95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95cd45bb9e3a2fe66b14a2ed06ae99ece75b6bd33222a9c5ee790a38c6226b95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95cd45bb9e3a2fe66b14a2ed06ae99ece75b6bd33222a9c5ee790a38c6226b95"
    sha256 cellar: :any_skip_relocation, ventura:        "c00d555f5915e77d6ce1fdc569d71e4b57e754aa63348c0bfa745dc0a328919e"
    sha256 cellar: :any_skip_relocation, monterey:       "c00d555f5915e77d6ce1fdc569d71e4b57e754aa63348c0bfa745dc0a328919e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c00d555f5915e77d6ce1fdc569d71e4b57e754aa63348c0bfa745dc0a328919e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d997c879a277e0da9dc83dbb4f0fe4b2f0c71fe521d35796f59ab20c946e1003"
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

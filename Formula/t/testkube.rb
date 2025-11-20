class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/2.4.2.tar.gz"
  sha256 "2c6e8187e7201b99fbe74fae150e60d6e89e90d00e3fce0a9e9240865b3474be"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2086e70f8d08fa8002f901a55e32e91c881cb71cefccc641845edaa8db9ed447"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32cec6cd76cdd8b607fd0766dd238c0eb62b3d3a93190302ba4f4b542e828e81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "299eb5da18756c92100551ea28364ea8042fa51e4c166f9b551da4778b75bad1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1291d5abed87695eeb1c19ef9f7bb06956b61cc9363ab17260fc0372967a2554"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec9ae230592832466626093a4d05ba1eecab0049e38ea7e72012ac0191dd4723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9c005a95afebe92f1901af27d41b9dcd7c0b02420ea58737e646165ffdcd87f"
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

class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.7.20.tar.gz"
  sha256 "4cf8791eb9172539c6f2d62fa81cb52bc3f6bccc0f40276b5ce909ebac02ef55"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea06396c7bc47be1c7779e37d936168009253b37c9488c3ef8c939aa3a4d4f91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea06396c7bc47be1c7779e37d936168009253b37c9488c3ef8c939aa3a4d4f91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea06396c7bc47be1c7779e37d936168009253b37c9488c3ef8c939aa3a4d4f91"
    sha256 cellar: :any_skip_relocation, ventura:        "5ba0422f32b4d0430b105b87e44894d984609843a41d3d1b56309aaf3371f80d"
    sha256 cellar: :any_skip_relocation, monterey:       "5ba0422f32b4d0430b105b87e44894d984609843a41d3d1b56309aaf3371f80d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ba0422f32b4d0430b105b87e44894d984609843a41d3d1b56309aaf3371f80d"
    sha256 cellar: :any_skip_relocation, catalina:       "5ba0422f32b4d0430b105b87e44894d984609843a41d3d1b56309aaf3371f80d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab906ef92a7bf2f9774c71ebc60050b5acbde3c2fd68ea88589cbc3945df60c6"
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
    assert_match("error: invalid configuration: no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end

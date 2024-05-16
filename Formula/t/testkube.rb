class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.17.34.tar.gz"
  sha256 "30cd934d441f7757200f091e0e0a4b0e46e85b35346488244d5a54942b9fe6d2"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38ad166338bd3fc287c06641458837d9e3b52a362b5fbf3bcd3aa37404fc2192"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd13cc2cffe606e7a8da05e676f08cbe7bf679c66cb6e70f346bcfb78c192e54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0225544343313851d53bc8f322790da8d5b36580f626b9b054d1ac0feebbe1b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a170513c9293e85fd65b607f992db69e8769f671e417fabc1d67fe5447552ff"
    sha256 cellar: :any_skip_relocation, ventura:        "69df3ff872b679f6e54951319138cfd9a89828aedcedd81474c061da2d0e2ff7"
    sha256 cellar: :any_skip_relocation, monterey:       "7d1900093f0abca04c780fdd56362d4995d0a10b1bc28ac7d85a4a02e09b2d05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc7e5ca0b2262a4c4ee1c353c94bb85ec855c4cdfcafef5b5b1d0785d7f919de"
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

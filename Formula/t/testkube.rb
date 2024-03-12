class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.16.37.tar.gz"
  sha256 "c5dae6ea791c5bda37daee2c5be633481e8df9546ce29907aa82c18a1fc3a47f"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6a1f42d52d9672fca8de3cef9564a35bb94e1c6ce89b07622b06faa51bfd6d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47b974f74ea6e7dd5e162d714ea7470ac104ada8637e2ca635986e88cc654745"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "192c36148cd349588801853ef273c3e8f935e6585f6b350bba0e1bd83ed33dc8"
    sha256 cellar: :any_skip_relocation, sonoma:         "7101b3684e795be73c5e2ae0d841bfc80e35343c0985e61f7b83b606b72592ed"
    sha256 cellar: :any_skip_relocation, ventura:        "7147f088dc7e3090ce73e91ea4fe3b24583f226f59d93c75cc3c2d644bcc0808"
    sha256 cellar: :any_skip_relocation, monterey:       "ac029e6905ee5fb3dcd4ea07754ecc52f2d71cf6372e4072382cec25b7c0db51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81e16233142d24d1161e5f8582206709ab004318ebc9cc646f2b98ff1ff07c46"
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

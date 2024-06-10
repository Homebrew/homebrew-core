class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.17.59.tar.gz"
  sha256 "8157d618a7348b199b5685701f774bcc82cd05f0c3e0398f80bb53837dddf8fa"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6adb9e45cc09513497640f76d1231405d655e22443615b2bd67507bc2acc4da1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb3a8d2de0689940f8371a4ea04d5d4a59795396576163b4b0b106887905e434"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29f5782b2b6bd0a6d0bae78c7d5d3788a85d78d0569d129564f62f198594c97c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e86108adff773416b3df6072056dfdf2e798d5dbe6940556783c84349d4a924d"
    sha256 cellar: :any_skip_relocation, ventura:        "9871b45b98a77c3dcf473583347d31c72ecda0d6508382c10586428670c9e60d"
    sha256 cellar: :any_skip_relocation, monterey:       "20f28492c338e1000101b7ec46f283fef1eb2837115e56ef36288ecf17d75170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7e3061217bb99a863bde5120ed74c0024d526ea0e4922d44c9d531d87883ecf"
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

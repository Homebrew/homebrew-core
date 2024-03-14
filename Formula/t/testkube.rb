class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "773a58dc4fcac269d9938fa7df6e0e3ddd11552f2308a25deb33e92228cf4e2a"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4835a66c104a53c7f5fcfdf783bda3d2c986f69495b523c1f7f16824301547f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ece746e0384b9f81c44ab96068338d6b02d6df7e26402fc216199f064a53861"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f88998f27d8283e012c92d5d83f66408f5b9e7b07f714c1241fcd9c51d2f27a"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b7bb2233c772ad44269b0638c08f59a401543a917b5eb63debd51ba21066ccd"
    sha256 cellar: :any_skip_relocation, ventura:        "ecc1660039d45f8067303f6be67ad87cc0e68a7a49bfa4f6f42b2e4a081c0692"
    sha256 cellar: :any_skip_relocation, monterey:       "52eceaeda406714ec949b37767379cfb103dadc95833f876e299f7415f334754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0cf1aa212af38211b5cdfc106b1f76e5a3d19bc79b13c6a120c08dd30a85ae6"
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

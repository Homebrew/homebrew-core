class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.16.29.tar.gz"
  sha256 "de8a70c50d60345f2e51929fe02a78b10d67414641fa408b86ef0a5aabd143c4"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa423ae19bca1a24ae1cdfdf4c4bec60d30a96433e2e551156a16fe1997baf38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4510b66babaacf32ada186575d6658c246d8e8b7e8ec1b775c4f2a97fef7e66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f22e0dc514b7cf02ba3d7e26e7545481174f76ce83aaa6b9a41eec79bc0ea022"
    sha256 cellar: :any_skip_relocation, sonoma:         "44a73b132b405e68164ae7e3f3831030c4d5e9b6c0123db7ecff8a1d593f29c3"
    sha256 cellar: :any_skip_relocation, ventura:        "cbbb8a7147b2d72815acf47e4435b7c7c27d498acf8ca3c645f68870263b377e"
    sha256 cellar: :any_skip_relocation, monterey:       "ffda79d0ddc41f512fd42fc7708951d715d2478e8684a13ad2eccbafb1239ecb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "781612c80565b6687d74c364420e6d32eb3acb16a829249cf0821d9689cfc215"
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

class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.2.9.tar.gz"
  sha256 "401e660aac9474cf1a9098aeb4a333a876d9afaa0c3c8cbf498586b208e7db80"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5124e07d088ae7fc3492e5408a7adc503882fd1b9ad211af3aa64ca85e361e62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5124e07d088ae7fc3492e5408a7adc503882fd1b9ad211af3aa64ca85e361e62"
    sha256 cellar: :any_skip_relocation, monterey:       "2eb8b9283cf65f5d3bc8e9fd7f4036b2d280455dd921f21d87a472b13804bbf1"
    sha256 cellar: :any_skip_relocation, big_sur:        "2eb8b9283cf65f5d3bc8e9fd7f4036b2d280455dd921f21d87a472b13804bbf1"
    sha256 cellar: :any_skip_relocation, catalina:       "2eb8b9283cf65f5d3bc8e9fd7f4036b2d280455dd921f21d87a472b13804bbf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbb18baff011e12f465444894008d1dd3424dcfed806b372620d9a43e5597e06"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags: ldflags),
      "cmd/kubectl-testkube/main.go"
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("error: invalid configuration: no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end

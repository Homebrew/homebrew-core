class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://github.com/qiniu/qshell/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "b5b9f88c826a1221ee1567c6e5880d1466e4dac791d95e34960319d904a66c81"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53a626e6418fbd89e846216579bfda42913939638d14c1a69e6a0a6159edc836"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53a626e6418fbd89e846216579bfda42913939638d14c1a69e6a0a6159edc836"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53a626e6418fbd89e846216579bfda42913939638d14c1a69e6a0a6159edc836"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bc8f537efde493e08f6363e05ce3ac5cf3e874583d21ebfa724f57500e6e1d3"
    sha256 cellar: :any_skip_relocation, ventura:       "9bc8f537efde493e08f6363e05ce3ac5cf3e874583d21ebfa724f57500e6e1d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af0e9802cf95acfd4192c6b04232b0b5cefaa8cdf3f391728ae0e183c86ab755"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/qiniu/qshell/v2/iqshell/common/version.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./main"
    generate_completions_from_executable(bin/"qshell", "completion")
  end

  test do
    output = shell_output "#{bin}/qshell -v"
    assert_match "qshell version v#{version}", output

    # Test base64 encode of string "abc"
    output2 = shell_output "#{bin}/qshell b64encode abc"
    assert_match "YWJj", output2
  end
end

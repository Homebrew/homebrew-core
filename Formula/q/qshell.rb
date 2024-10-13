class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://github.com/qiniu/qshell/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "1bb1eb9c7c71c0af7714fa49b04b5e27c851e49a0f8fb0360254cb3c9f4ee472"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cba294b507ff250ed3a688cbeb20d6e52c14b78f39b092725daadd56c5669946"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6fa3a186562a263f6980f38a10decd812898833623b8904a17fb158c1bee4bd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b56d1e101453ac0992e72ba41d6cb8099ff533f288c436532d345060e0e82286"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e5bcc911371e247f82f2912116b50ae9a8ba4e1c4a54c82df92313fad722955"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb055ae85801b90f89fac758ce9df6cf8afc69dc225346bae6f8087a1d0185fa"
    sha256 cellar: :any_skip_relocation, ventura:        "4f6b122851a0661bc2dc2b7ce834d2c755436b28d4046355fe2fdc4dd50d0027"
    sha256 cellar: :any_skip_relocation, monterey:       "ca14664cb34be1b80cd2e542043b95b44d1a8f5c4930aa29fc7d6340f606e4cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daa3155554a6de7acf972805fbf4352bcabe27f8b930c07812f885f02740c57d"
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

class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "1fa1496c6f5aaadd1656db1d03ce58624ffab42511057d1addf3b8a4ab4f2372"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d6e999a3bc2b53e75d055c2421b76f9b4ba0d0da4daf3d5cf5396b960683fd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d6e999a3bc2b53e75d055c2421b76f9b4ba0d0da4daf3d5cf5396b960683fd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d6e999a3bc2b53e75d055c2421b76f9b4ba0d0da4daf3d5cf5396b960683fd4"
    sha256 cellar: :any_skip_relocation, ventura:        "59414e558e36df008d173b87172bd5d9e227d1a069492e9a43aec08a00fd5eae"
    sha256 cellar: :any_skip_relocation, monterey:       "59414e558e36df008d173b87172bd5d9e227d1a069492e9a43aec08a00fd5eae"
    sha256 cellar: :any_skip_relocation, big_sur:        "59414e558e36df008d173b87172bd5d9e227d1a069492e9a43aec08a00fd5eae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccfcf54d78d70884ed9e9ee505e0d0c31bd3e5f815f75bee8954a8a16716842c"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X github.com/railwayapp/cli/constants.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1)
    assert_match "Account required to init project", output
  end
end

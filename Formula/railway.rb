class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "1fa1496c6f5aaadd1656db1d03ce58624ffab42511057d1addf3b8a4ab4f2372"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecd4ff5d6aaab7c616e292b5519529d461f44bb6ce17488b51dc583238719b19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecd4ff5d6aaab7c616e292b5519529d461f44bb6ce17488b51dc583238719b19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ecd4ff5d6aaab7c616e292b5519529d461f44bb6ce17488b51dc583238719b19"
    sha256 cellar: :any_skip_relocation, ventura:        "34f496a5c95ffcb7f505bbffdce534a9470c4d2d158bea70d79d0dd1af2d108f"
    sha256 cellar: :any_skip_relocation, monterey:       "34f496a5c95ffcb7f505bbffdce534a9470c4d2d158bea70d79d0dd1af2d108f"
    sha256 cellar: :any_skip_relocation, big_sur:        "34f496a5c95ffcb7f505bbffdce534a9470c4d2d158bea70d79d0dd1af2d108f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bce8a96cfa75c3c5e15a9ec2df3d2695b1fa20df38e5fe1864d1ef5555c0c206"
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

class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v2.0.10.tar.gz"
  sha256 "b0077fd4408227c4b5509971a220fd4ae5d8bec1b05d340503905a6dae306fdd"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac62150bcc8a24a7887c6c99277f11a8c9fddf4dc6fc8fad3b34eba3c8a616f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac62150bcc8a24a7887c6c99277f11a8c9fddf4dc6fc8fad3b34eba3c8a616f9"
    sha256 cellar: :any_skip_relocation, monterey:       "988fa630812995c0de740773b778cb67450742785e6776a8df2c3e99b378ad0f"
    sha256 cellar: :any_skip_relocation, big_sur:        "988fa630812995c0de740773b778cb67450742785e6776a8df2c3e99b378ad0f"
    sha256 cellar: :any_skip_relocation, catalina:       "988fa630812995c0de740773b778cb67450742785e6776a8df2c3e99b378ad0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db016c3394e1aa791e671eb2e408ae83345469cb78f5fd135e8a5a93957a8e2d"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X github.com/railwayapp/cli/constants.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    output = Utils.safe_popen_read(bin/"railway", "completion", "bash")
    (bash_completion/"railway").write output
    output = Utils.safe_popen_read(bin/"railway", "completion", "zsh")
    (zsh_completion/"_railway").write output
    output = Utils.safe_popen_read(bin/"railway", "completion", "fish")
    (fish_completion/"railway.fish").write output
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1)
    assert_match "Account required to init project", output
  end
end

class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.3.1",
    revision: "101df332f1c4f6fd95e9e8828aeeae44631fcf31"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1ab3c9a6691802d498e62a2d33ef1d2a2cdb9906fdbc5f770d2619c240ca47c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "580c02c61b84ce3f0c07b9830baccac482b77d87ff7a90cdc16907c924ffdf99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a9c34ae4f60d4ca4de5c76562fdd2cfe8bb98bfe4ca2f08f42da7b12867a90d"
    sha256 cellar: :any_skip_relocation, ventura:        "5a8ea0dc8cea6727345b99f3a93e4db5a72a87240da1913bc2fda810f729fc01"
    sha256 cellar: :any_skip_relocation, monterey:       "32ada49a31904eb40fdc734e8a539f8afda3d9b3e0d197d38b6c1f63170b079c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f358eabc81d7c1ceaf30018ffe1e4bbe1f701be3ad81b5e66886a6f826f98bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e19c2a95336d1ec86c15bfb341c43591a52adcce17005a4f257a52f32134bf8a"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    prefix.install "bin"

    generate_completions_from_executable(bin/"yorkie", "completion")
  end

  service do
    run opt_bin/"yorkie"
    run_type :immediate
    keep_alive true
    working_dir var
  end

  test do
    yorkie_pid = fork do
      exec bin/"yorkie", "server"
    end
    # sleep to let yorkie get ready
    sleep 3
    system bin/"yorkie", "login", "-u", "admin", "-p", "admin"

    test_project = "test"
    output = shell_output("#{bin}/yorkie project create #{test_project} 2>&1")
    project_info = JSON.parse(output)
    assert_equal test_project, project_info.fetch("name")
  ensure
    # clean up the process before we leave
    Process.kill("HUP", yorkie_pid)
  end
end

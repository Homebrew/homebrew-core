class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.32.tar.gz"
  sha256 "3c80a9e489f2aea2da68f0bbf34700f2456b85f785033422444b0079326f283e"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26827a89dd823ea685e84b22eae3da317803157589327614e2cabdd7cec9b477"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "062ad92e21ac04dc48187d0427273a928d04def679b4086f62fa8d820be32550"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1656e2bbf846ef9ee1043b3c067d4b29eaa6787a4dbcded63afa4d30ceb27c95"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f88e16478a5882f0dc0215134aacd9de6d349f868fd49c3ed68b516bed9ebf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad428ec1e3726314d20032e4ec49282eabfe1e49c2673abdb784b0942118096a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d9b8cdf13959de8d6291dd6152506f36c9a1f4288291df99203106f8ed259f1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/yorkie-team/yorkie/internal/version.Version=#{version}
      -X github.com/yorkie-team/yorkie/internal/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/yorkie"

    generate_completions_from_executable(bin/"yorkie", "completion")
  end

  service do
    run opt_bin/"yorkie"
    run_type :immediate
    keep_alive true
    working_dir var
  end

  test do
    yorkie_pid = spawn bin/"yorkie", "server"
    # sleep to let yorkie get ready
    sleep 3
    system bin/"yorkie", "login", "-u", "admin", "-p", "admin", "--insecure"

    test_project = "test"
    output = shell_output("#{bin}/yorkie project create #{test_project} 2>&1")
    project_info = JSON.parse(output)
    assert_equal test_project, project_info.fetch("name")
  ensure
    # clean up the process before we leave
    Process.kill("HUP", yorkie_pid)
  end
end

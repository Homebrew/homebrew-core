class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "94a0cf3fc5c744508b135ca124903fbcfd792fcaad7e78c4c5b097e16cd1d0ac"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e0ba5525af93d2eb0ab8a10e06a481172af6fbb7cb3e4ec5f3fd2b09994ce6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24e1d64768c158ca62d246fb1efd74793ee1c040ce7059935d25ff3a1a4d7664"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd7e572e2b1b2903ca6ab94f52967babb4e1ea2ee49dbdcb62e9de136ad98406"
    sha256 cellar: :any_skip_relocation, sonoma:        "b77ff65709ad9254546aa3e637405cf6d35bc3d0ab487699201d79f014f884ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59af98d4b5c6991097515d5ac568410a71d69b2dd096c9aaa998b2afcc59df71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e081b40d66cdd736a8fa155bfa61f7bfc9614c5822d8cb9012b1fa8fa769b8ef"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/yorkie-team/yorkie/internal/version.Version=#{version}
      -X github.com/yorkie-team/yorkie/internal/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/yorkie"

    generate_completions_from_executable(bin/"yorkie", shell_parameter_format: :cobra)
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

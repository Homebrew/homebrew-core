class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.22.tar.gz"
  sha256 "b484537f92f405aeabd3ee00100c264388b2a98dd65a70233da7b5e49f9337f3"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4552443f138491b5f9cb1f88c65c944cf5643c7c782135812831c3e62d37f494"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a39bd9dbe8458847a384efa39429091f51090772d76d1b420ea963e28b83b642"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "10c966975f2565253f6542c226a555f0bc15e863f95ccab8798af2a2f04190ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3b5d1c6aee10883583b56a7c30e1be910885fafb292ad04c8d95dd0319e79de3"
    sha256 cellar: :any,                 x86_64_linux:      "7e4ec50375e5bf31b52e2a3631761c9c2e61fe3360bd524be26e53ad191eb275"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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

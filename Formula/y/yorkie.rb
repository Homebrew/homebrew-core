class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.31.tar.gz"
  sha256 "fc0de3c23edecef2a4ff554dd4ed5bcb5f4b16286128b20b18b7bd9c602d4b68"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91d42d17a9551f172681789882f998926f928ed23a6f26f867f5c02b3802e58b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "caac446b5574bf1866f294fab9ea0f8c406cb2efa824e1e9b08f5b74e69feb54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb82888a4f911f7ec4d541bc8fc1907578ae0d8917938bd35fa73238d371a23a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b486889e3f12f4485d1408644f072a3a324227ee7a93bdc0c800b08f3eea3f2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01bce48c5abc36ba3390b3062dc63fbc6962111f428ee51766af508a5682e327"
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

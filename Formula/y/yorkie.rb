class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.9.tar.gz"
  sha256 "eee58566b35fa9d35e744a7cbefada6803b966c78eef191c94ce2f99ee26bd97"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00fbb3d71ae78246a2723bb5c8ea738e3948ba53e28cd4944d25fa9214b449b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00fbb3d71ae78246a2723bb5c8ea738e3948ba53e28cd4944d25fa9214b449b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00fbb3d71ae78246a2723bb5c8ea738e3948ba53e28cd4944d25fa9214b449b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bf1a8617ba0ec07256f00965a0990a873123aacbbaf6057b1f8bf9ddd54e7e9"
    sha256 cellar: :any_skip_relocation, ventura:       "3bf1a8617ba0ec07256f00965a0990a873123aacbbaf6057b1f8bf9ddd54e7e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54d3df7e85a519f39361e3814d0c8710cb4197b8ec67814daf3b69bb833596fd"
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

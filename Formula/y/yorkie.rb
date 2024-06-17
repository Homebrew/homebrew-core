class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.4.24.tar.gz"
  sha256 "8a0a7d1c9c4bdc8953b5f03510d1e5dc3c23bf7e3ac0a404b318ce8930b3e70a"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8f24e1d25c3bc4860f0143bcea1b8a3877d05a6b0be3322e6ccda8b686577d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "770cc46e1a8aa09567eb1ca0b7149881a3ed3ed8d5db105c6047ba00b7f8cac9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95e13df81b563018b4863a12c6ae44508d89476f57b4df7e4a89aa4ccca9ab28"
    sha256 cellar: :any_skip_relocation, sonoma:         "72295f2fb9dbac9aef5ee64c781afdd246369994db87f5754ab1eced8537bbc0"
    sha256 cellar: :any_skip_relocation, ventura:        "5c0a5674027c091a1e7d2c15cc11d5c0139898db04acb60f6269ba46c664c8d4"
    sha256 cellar: :any_skip_relocation, monterey:       "19da36ca8a53d5c2c31875b1ce3fa88063c9b222fc7883b229136eee0535674d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b3358e959c0c4345af214e5771a1df4fbfa95c352fed6486b34a541a7266a00"
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
    yorkie_pid = fork do
      exec bin/"yorkie", "server"
    end
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

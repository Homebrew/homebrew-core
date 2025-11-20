class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.38.tar.gz"
  sha256 "c4967d04b6c940a34c08a852da187c3e46a8e92fd6af6005fc658109fbbe509d"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b2026e18d86937d8e55d674c2b7a8c7170537ce149e856eb5e90e9051fd4e6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "896e20d4c124cbdefcb98435c4db1c4d9d5e483272cd51350f3f14f7a5eda13a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6320c975dba459f0fdfe508520b7977e318ff9dcebce92842bab0b7113527c07"
    sha256 cellar: :any_skip_relocation, sonoma:        "071dc05375e9d1f0dc87a8ffbfc62931d75c9c524e30e12b80ffbdb6a5760c6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ea7a857a5767a8ab5972464b32bdb74095ec584e20861b29f97be7c9bb742c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0b574f137797f5e85365579d02cdde3cd4e07e30af721821de9ea5fd25df480"
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

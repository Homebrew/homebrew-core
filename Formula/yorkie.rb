class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.2.13",
    revision: "0cca5e25b8b83ad5b389f84735324a016f9691f9"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f0582d14ea566f90612a320d487ee253b60a9a9f320f2879cadf43b2f986247"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd45360489ff4fc27a7f8dfe814423c64bd52efc9c10b960272bc821f8c51942"
    sha256 cellar: :any_skip_relocation, monterey:       "8eb581b16090e698d99368782a7dfd226f05529ae61007eefb122611a98c0ef8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b271d4e6b0809253a0353ef644bf5558966b87dc700fa66066844eb926facb3a"
    sha256 cellar: :any_skip_relocation, catalina:       "3ffb4b3a6d66ac73e9e098beea491f603f89b8f180c0f387d4b405b34be91176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "664b61c007bd4110f9003d28a341345ed0f1c600a543c6bfe472e595437a9163"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    prefix.install "bin"
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

    test_project = "test"
    output = shell_output("#{bin}/yorkie project create #{test_project}")
    project_info = JSON.parse(output)
    assert_equal test_project, project_info.fetch("name")
  ensure
    # clean up the process before we leave
    Process.kill("HUP", yorkie_pid)
  end
end

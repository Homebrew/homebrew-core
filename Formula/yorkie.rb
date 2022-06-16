class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.2.7",
    revision: "d5a7dea64f9353510f95a396ae7cfab5d64a376a"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2572898c5836fcca5f89a7876388b1f91f47d6f9f9d646e5bf86bb8911792b9e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2de1ce27177d363ddab9388865d39a1f78d9804ead5c300fa113f70263f69a9b"
    sha256 cellar: :any_skip_relocation, monterey:       "34e309f620e084fc818c48152ace74451e0c3fe1e292845fa67cca225b10ff0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcaca9337a32d1826c9d86b39899decd0063808dfd4af03394ff17ca5f434981"
    sha256 cellar: :any_skip_relocation, catalina:       "334d13e3287ad6fd5789ac713607fdb6291a1d754c9fc1ed44a3e5600ca02057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52707f707983de19e68dff372c12ac9c3255cb98e1ac9d0170f098c795a8352e"
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

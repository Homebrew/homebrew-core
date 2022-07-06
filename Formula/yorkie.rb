class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.2.10",
    revision: "694d467ddb85d6f9c0fec4e4d583d058bfb00fa6"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "143bbd0f756c322edc5213ee50e58bbb3dd1f9adc33baac4316d63333e851511"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8db0f06cefe686bebb2ea4cb5efb14cbab1a99c1c8706f94dea27c74bc8d04c2"
    sha256 cellar: :any_skip_relocation, monterey:       "32162b97f5c246258cb808155f52d96ab811e5d80a1ff2aa7d8528fad2822848"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f6335bb611763aab623401954b677f573541d7d70f23f83ec2e2cb6d5b6d71a"
    sha256 cellar: :any_skip_relocation, catalina:       "2f9dc77f15bab59ab6014d1fcfbe2542a38f6669101b9429e4dce606a7676736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c091a104ecb1b2aa7296b998147f5475c69a37113b641cb6236447e6ec11a1b8"
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

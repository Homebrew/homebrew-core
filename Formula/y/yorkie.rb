class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.4.11",
    revision: "34d960bfab38085968609744ead42a4d09944602"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "569a6e540bb820c722af76dad351091f181741f8addc3f5892c3b47126fd0002"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e30182fc5e2545683df2cc851ce29379be1a9c9aa5848c9ea6f70b9cf7be2cad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0db072415976182fe799ac338286bbdc41a64913ecea4e513a6b724d1e4e3b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "d316aac2711144d5afa3d9c89dc03bb9e9b93e6b0ba56ca374180a6605fa1ade"
    sha256 cellar: :any_skip_relocation, ventura:        "67f733b2a301007c50ce06c0ad36f8fcf45d49444e05ed32de1968d9733009cc"
    sha256 cellar: :any_skip_relocation, monterey:       "591a8df2c155f4ca3c4aafb183664956a841e621857b1dfa88600b9cc8fdfc40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10a2165af8548c5a2ceb5aa273765dbed89ef58b89f5f059ae71450d617b3ba5"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    prefix.install "bin"

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

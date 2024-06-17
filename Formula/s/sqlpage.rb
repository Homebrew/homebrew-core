class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "7860367ad875894ef11860a5ea3716fc41445ed7d7b4746c5c34d8a243d6559e"
  license "MIT"
  head "https://github.com/lovasoa/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ea79cc3c7f65966022d1c327cf7e9e504bf3eb103ae5570e0b81848b932fa16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd092d29f91d2f0fa227bd5ec713e3a816e66dc434ec2f6d3ec8ee05e45a8408"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e8451ed1b1f36705578ba9d8be5309f806b53c54b5be6033ce4c79bc6d7be88"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ddeb72f4a65915bf07a9b6a42d29ab80baf91da57980acd26f22910addfeccb"
    sha256 cellar: :any_skip_relocation, ventura:        "ccba9fa379b020be884a8cc20cb6dc25f42d813310a16be180a276e69eb9feb4"
    sha256 cellar: :any_skip_relocation, monterey:       "cc6fd8ae05a376a7c7dbaba5e3b4a978ebfa1d15e798c0f4c8f86d65130b2d49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd977267ff20dfb846947db6c7c39fe7238b828cdfaa18956eb256ca494c6fca"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = fork do
      ENV["PORT"] = port.to_s
      exec "sqlpage"
    end
    sleep(2)
    assert_match "It works", shell_output("curl -s http://localhost:#{port}")
    Process.kill(9, pid)
  end
end

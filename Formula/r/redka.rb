class Redka < Formula
  desc "Redis re-implemented with SQLite"
  homepage "https://github.com/nalgeon/redka"
  url "https://github.com/nalgeon/redka/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "c5b1746f5c1af905d79247b1e3d808c0da14fd8caf1115023a4d12fe3ad8ebe4"
  license "BSD-3-Clause"
  head "https://github.com/nalgeon/redka.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d76c91050ffe415ee014050dac28fedb3983a99ddda83e6a04c4009b7a100313"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2afe1b51f17c267bd70f8ced5c96f3d4f3895852883fa19eaba5145c9df7bc62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8be640a9fe22bb2c23b00fbd7932235ed62dc3aad5fe1dabb1bcc9c9f0ae4e17"
    sha256 cellar: :any_skip_relocation, sonoma:        "41ce5588bf143a988a41ef0ee17c6e4d581a8e326372c74accd54bcebe1529b1"
    sha256 cellar: :any_skip_relocation, ventura:       "bb78c4e52d6177cebaf0f1d1afabaf3da46c85841b6feb0e312a605123035d82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8043e1f6e3e88f408e482c41fd195db76126720f546449358728eff9ef6ddc57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a518059a8ea13f550bc38204414142a839adba3458eb31808b17e1a438a59d0e"
  end

  depends_on "go" => :build
  # use valkey for server startup test as redka-cli can just inspect db dump
  depends_on "valkey" => :test
  uses_from_macos "sqlite"

  def install
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"redka"), "./cmd/redka"
    system "go", "build", *std_go_args(ldflags:, output: bin/"redka-cli"), "./cmd/cli"
  end

  test do
    port = free_port
    test_db = testpath/"test.db"

    pid = fork do
      exec bin/"redka", "-h", "127.0.0.1", "-p", port.to_s, test_db
    end
    sleep 2

    begin
      output = shell_output("redis-cli -h 127.0.0.1 -p #{port} ping")
      assert_equal "PONG", output.strip
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

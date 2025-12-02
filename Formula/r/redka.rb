class Redka < Formula
  desc "Redis re-implemented with SQLite"
  homepage "https://github.com/nalgeon/redka"
  url "https://github.com/nalgeon/redka/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "cfccbfc5b4887211146352426efe0c3fcc2adbcfe71ef6b58da3d29cba867bde"
  license "BSD-3-Clause"
  head "https://github.com/nalgeon/redka.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b9c4ebbe474efe9850a4139102c097b1fccfd91dd577f0df06cd8f9d0b3b400"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7369c85e3dd72b92099608984ea0fbab5d2e54bfdca89184f6f843c5e46c6d45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e477b72b5298b8a1f198c27b470567ebeb117c1f5bf5e5c0c3144c9cc827c085"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ad393f56c26de9ef969ad9ccec620c369447267b55c8e5ab1967c15ed52d9dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8609f1f2f966c9340054ff03d194f2ba8c2093d3ff02030f582433574fdb0e6"
    sha256 cellar: :any_skip_relocation, ventura:       "3bf7ad1ccb15e6ab17d46509a843db68f4a27fc327982e0622f808158841f693"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a684c766952001e2853f8b343d8873e583c7d9ca92fbbe669b0ad06690059e86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb41ebb4b8424561c5666d214b33d25e9a02a2837e708fb2d78c1b0c9873bb24"
  end

  depends_on "go" => :build
  # use valkey for server startup test as redka-cli can just inspect db dump
  depends_on "valkey" => :test
  uses_from_macos "sqlite"

  def install
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"redka"), "./cmd/redka"
  end

  test do
    port = free_port
    test_db = testpath/"test.db"

    pid = fork do
      exec bin/"redka", "-h", "127.0.0.1", "-p", port.to_s, test_db
    end
    sleep 2

    begin
      output = shell_output("#{Formula["valkey"].opt_bin}/valkey-cli -h 127.0.0.1 -p #{port} ping")
      assert_equal "PONG", output.strip
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

class Redka < Formula
  desc "Redis re-implemented with SQLite"
  homepage "https://github.com/nalgeon/redka"
  url "https://github.com/nalgeon/redka/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "368cfae611fcf908019f7f37d9fe400fd13b8c87c9ad0a091563c9aa6461f7c7"
  license "BSD-3-Clause"
  head "https://github.com/nalgeon/redka.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5812ac99de3bb11d6ca678b33a9e27b9a6926ce6ec94383d4e012ea57ceedd59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "717f0b8459551d90c97c2d9c3969c6a01c2df71d4b58929a767b33ba7469e3ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22d95e7745822d5d65c1ecbb9a7f9125ffda500a779275a7716143174faa52a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e097eefacbb60c621c164a1715a4104b519aa1a619c8c529b01b176677d8a31d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "351f5f86f1b2a06f930266abb6261423d0fd682cbf823e0cc0edbe6d2fe63762"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2ae836a787ad4fda861f459eddfe9b4a6deb24d2f8ed96e2fe020334518a702"
  end

  depends_on "go" => :build
  # use valkey for server startup test as redka-cli can just inspect db dump
  depends_on "valkey" => :test
  uses_from_macos "sqlite"

  def install
    # Workaround to avoid patchelf corruption when cgo is required (for go-sqlite3)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

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

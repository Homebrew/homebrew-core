class Shpool < Formula
  desc "Persistent shell session manager"
  homepage "https://github.com/shell-pool/shpool"
  url "https://github.com/shell-pool/shpool/archive/refs/tags/v0.11.5.tar.gz"
  sha256 "171b678b38a504c2c8fa53cb8c4fcc4283fd107c12eeabd1b93d76c4a25d2087"
  license "Apache-2.0"
  head "https://github.com/shell-pool/shpool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f3a671e684c5198597f86833f97cc14c80fa056767d00a2b3e4443d5cbb0da6e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "892ed6628c22b557505449832a972ca3c0a3bae5284ef8ce1ad6ee07615b296a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "20fc8958227d0ce772fe6ac80d3389885c9b321eb13c7c9702824c238039fac7"
    sha256 cellar: :any,                 arm64_linux:       "cb9099cd963d583bac24fa9d8712b5e4cddc5d20e2cfac0f7ed3119fa5334bd4"
    sha256 cellar: :any,                 x86_64_linux:      "b00ca33126df664ebe740d7e09a8ebc9c414be8d57ded886aab5810d1c91ee83"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "shpool")
  end

  service do
    run [opt_bin/"shpool", "daemon"]
    keep_alive true
    log_path var/"log/shpool.log"
    error_log_path var/"log/shpool.log"
  end

  test do
    socket = testpath/"shpool.socket"
    args = [bin/"shpool", "--socket", socket, "--config-file", File::NULL, "--no-daemonize"]
    pid = spawn(*args, "daemon", out: File::NULL, err: File::NULL)
    begin
      sleep 3
      assert_predicate socket, :socket?
      sessions = JSON.parse(Utils.safe_popen_read(*args, "list", "--json")).fetch("sessions")
      assert_empty sessions
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

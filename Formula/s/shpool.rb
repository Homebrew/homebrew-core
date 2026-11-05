class Shpool < Formula
  desc "Persistent shell session manager"
  homepage "https://github.com/shell-pool/shpool"
  url "https://github.com/shell-pool/shpool/archive/refs/tags/v0.11.6.tar.gz"
  sha256 "3b8b50cc220fbd4d55f0071e8bd9aa77f035d73fb8797ae39ed883b1619d1864"
  license "Apache-2.0"
  head "https://github.com/shell-pool/shpool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d97c2ff4d354cb24ebac195c92c187eac4fcee368b9b6351124ea301d0222029"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d93e46eb45c24cd9867c573a3f3ea80f804bf5c9799c35e8f8bc946417b50e97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "659d8024a8f02e77dd8afba9d507df2a4b36e3d62b9eecce4029079a188e7d37"
    sha256 cellar: :any,                 arm64_linux:       "173ad7de5dc471a0b39033dd9d67b13db3b51fb1cc7b719a83ec41de2fb3f9f8"
    sha256 cellar: :any,                 x86_64_linux:      "3c0137632c550ae05f8586db56dd0d8cf9dd6f6d7af48e557ce4f127e4f53202"
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

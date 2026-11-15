class Shpool < Formula
  desc "Persistent shell session manager"
  homepage "https://github.com/shell-pool/shpool"
  url "https://github.com/shell-pool/shpool/archive/refs/tags/v0.11.7.tar.gz"
  sha256 "a521a6fc38434c6f881145b726ad4101e4bd1dc06f6f17260fdb881b52f172b6"
  license "Apache-2.0"
  head "https://github.com/shell-pool/shpool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "72ec397c6d873c0251feee74c9a79711b03133f855782159f2e53399c449280b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ba86152b660fb83d52f2ec08b5bec088d0deccd6c9e6b6b313617d04590dfda6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "de7f2dd3a8903729d2f6de370e0ee49b587f20656c873cc929247e1c5893af94"
    sha256 cellar: :any,                 arm64_linux:       "f0b3d0201c717954bfd23d978a28c11348cf139f471aede3fd92b8040a42cca9"
    sha256 cellar: :any,                 x86_64_linux:      "51615bd83a356ea5df941250ef41ede269dd78819fcb4f1279ed13e2c9ff503d"
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

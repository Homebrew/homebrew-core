class Shpool < Formula
  desc "Persistent shell session manager"
  homepage "https://github.com/shell-pool/shpool"
  url "https://github.com/shell-pool/shpool/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "1fdf2cd7540fdc555ced8948585d57359e889577749aee019a6ded57265719f0"
  license "Apache-2.0"
  head "https://github.com/shell-pool/shpool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb1021b2c62e8a63745f11e58797a3d0e028a8b5e91ca266f64f61c5caef0426"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07d976ad390ef19062701dc24a3dbb5c2a1e82726cfadf7277a4f72c9daa7a57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01b97265a1dbf0a451d305f2de906bc0283900b3432f9da053a5e13f288035dc"
    sha256 cellar: :any,                 arm64_linux:   "f140ca3e9e64514046e826d56d465bd7b86f5265194fd054e426bfa15da58221"
    sha256 cellar: :any,                 x86_64_linux:  "8dc62c5c3616b56a8b46b04a8d0ec71800fa6ab716c06a193abeb0ec4daff7e1"
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

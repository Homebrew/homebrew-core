class Shellshare < Formula
  desc "Live Terminal Broadcast"
  homepage "https://shellshare.net"
  url "https://github.com/vitorbaptista/shellshare/archive/refs/tags/v3.9.0.tar.gz"
  sha256 "9eaba669f636d22ed8511550696e9cc135fe81327fb84b94b76322eddb288412"
  license "Apache-2.0"
  head "https://github.com/vitorbaptista/shellshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b6d5be5414a637d622a07c76b20f02ef8d368224bcc55c4d8324d5fdf145476"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2acd403527eda408a246de682b8150cc67f66e88663f3d8cb0857729c4fed6f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dd5e4e11ddbfcf35da67a8dd2a0d6d028edd6c2b49ed715eff341cc59a9c9fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "04aee6b2097685222d70176452a90bd90a7d2a66221910d9e1783b401dae67d5"
    sha256 cellar: :any,                 arm64_linux:   "0d153b4e30e39a542fe9e6fd3833ed6a080e5a9c5e63f9194524259cd81711fe"
    sha256 cellar: :any,                 x86_64_linux:  "6122b1e7b0ef8522345a9d88b0d994932f7457e83ef6146b2693537f8193a951"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shellshare --version")

    port = free_port
    pid = spawn(bin/"shellshare", "server", "--port", port.to_s)
    sleep 2
    assert_match "shellshare", shell_output("curl --silent --max-time 5 http://localhost:#{port}")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

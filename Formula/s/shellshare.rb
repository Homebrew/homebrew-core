class Shellshare < Formula
  desc "Live Terminal Broadcast"
  homepage "https://shellshare.net"
  url "https://github.com/vitorbaptista/shellshare/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "f1619e4d7c604ffe6a2eac5b65529fecf063bfa10d592a23d556067a24a69acd"
  license "Apache-2.0"
  head "https://github.com/vitorbaptista/shellshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7155cee155b3b2ea60dd2d7e2331c60b34796fb009b3f26a0bc9aa7bcb712bad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "561a2d1a3f283a2cd6adc9025632bed740f776e504daffd382b3e719a2954b7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99078ec0e5f1a2cc217ce7e57ccdd9ed5fa11809757cac9ed60a01892a758509"
    sha256 cellar: :any_skip_relocation, sonoma:        "92aa641f95b14da2457dd3a1b458eb6f608a9476a8bdd457fa9208f481a0af20"
    sha256 cellar: :any,                 arm64_linux:   "c7eea874817cf5493d12d70da03177474d6819faab906f35992ef7f984b61917"
    sha256 cellar: :any,                 x86_64_linux:  "5bdc2920ecd358acf9f1b77542e4844b0a9e003b5585612b9276c2621330fba8"
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

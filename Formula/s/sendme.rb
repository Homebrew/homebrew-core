class Sendme < Formula
  desc "Tool to send files and directories, based on iroh"
  homepage "https://iroh.computer/sendme"
  url "https://github.com/n0-computer/sendme/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "57fb54bee5c279f50e3c2ee5ea4eb568cec8273e2bf4a4d46d92d693cd4a28ac"
  license "MIT"
  head "https://github.com/n0-computer/sendme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53f7f564690d0363038ee3b463bd3ea546996849bcc2170d4f9593e7eeabbb30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18e68cd5aaa4906af615a6099b3de20717ff122e314403a47347571ed49ca25d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4815aaf7b925710633de2a52be1b1b637d0ab28f98522bad11aa320bc65e54a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "08cc6d488ee7070f31741cf968aa06ecc8860266aa80991a39cf56041ba459ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "501353b1f9b04033a2abb6d911aee3fd0333fb7f7892b6112feafefa2cd2c41f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6019d29064031ef809c571ad224e2b2e12401f32df01019ace36bca2268c52f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sendme --version")

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"sendme", "send", bin/"sendme", [:out, :err] => output_log.to_s
      sleep 4
      assert_match "imported file #{bin}/sendme", output_log.read
      assert_match "to get this data, use\nsendme receive", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

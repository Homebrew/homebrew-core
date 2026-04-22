class Sendme < Formula
  desc "Tool to send files and directories, based on iroh"
  homepage "https://iroh.computer/sendme"
  url "https://github.com/n0-computer/sendme/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "75ed1cbb040100dcc6bf28228c3393e00d5d4305c6c951bf5df374ccb63e1621"
  license "MIT"
  head "https://github.com/n0-computer/sendme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fdaf77a8964a2b2ea7250bafb3f6851277b2f75a26ac404562aba4f37a0445b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c945e117916d9e326e7dba3ec97c9c3bc5d1208cef4052dea831b12a34d1d58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bfaf7570c3ff03201bb56dc66964f71339ef1dfa6bd46ebdc799e6e44795dd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7ab5d924cd9867d19fe91c331ce9fde00ac513753d0e289fd8db34e1bbe039e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7e4f78beef40a66c0e3b48a431ae178bf4da2814ea51f9889f8f453b88b2f65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40a412ec67288ba069701948c4ed327559037bf36da909d1c1dcfc12caa696f6"
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

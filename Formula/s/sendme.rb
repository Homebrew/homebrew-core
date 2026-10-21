class Sendme < Formula
  desc "Tool to send files and directories, based on iroh"
  homepage "https://iroh.computer/sendme"
  url "https://github.com/n0-computer/sendme/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "bbde0e324ffcb4c2fae6d8dd3af2c8191796be2d34bd40f354692c44eea5e9cf"
  license "MIT"
  head "https://github.com/n0-computer/sendme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cfe39c5fb0d4dff8d6d20caa87db749735825d91892fc8cd5149d17ac2368c89"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "38864808ab8db64d02df3edd3e152a0706d6a41a0cd074d9345412339a0322bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d19a6264bb3fdd3905164bd64f765b4fbf547dae920beed5aca44146a28c55e"
    sha256 cellar: :any,                 arm64_linux:       "d425c67c4688f75ae52811ef49b17ebfe0b839bcedc1fe58117cc2bc26432699"
    sha256 cellar: :any,                 x86_64_linux:      "ee32cb5a5e2022e8ab247945351559cc299cefa13fe84e48e3f0f1b8105b1993"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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

class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://lusingander.github.io/serie/"
  url "https://github.com/lusingander/serie/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "23f2631b8263c1bca47c616aafa0ffa7b6e39f50160e740eacd69afa9eda76a8"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bfc88704f6b5d1c8600f797f3d151286033387732549b5d72a9acaebdc541c8c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f31a48009cb7c14f1223adc42f2f4aab3e2f1e57c799e2d5cfe18f70c36ac5a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "416ba8c486b9d5d5659c2b6708427d8d8f3f1456e435f4017c284f763eae19c0"
    sha256 cellar: :any,                 arm64_linux:       "e63bfd2bb764a45cf144c506d1f78afde91b8d77436909296641ffc972fcb0cc"
    sha256 cellar: :any,                 x86_64_linux:      "92f68779ff800ee176f91284dd7a14ade7c520f6f4b01fa34ed43ee1b8c975d7"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serie --version")

    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "Initial commit"

    begin
      output_log = testpath/"output.log"
      if OS.mac?
        pid = spawn bin/"serie", [:out, :err] => output_log.to_s
      else
        require "pty"
        r, _w, pid = PTY.spawn("#{bin}/serie > #{output_log}")
        r.winsize = [80, 130]
      end
      sleep 1
      assert_match "Initial commit", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

class Rura < Formula
  desc "Interactive TUI scratchpad for building shell pipelines"
  homepage "https://github.com/tlipinski/rura"
  url "https://github.com/tlipinski/rura/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "4ce5db5337faa6ebf50fd917b11347d3ff5367a554c1986472620fae4cc2c678"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f8e08ea527b02edae098744f484c30b467fc1a6341be8a1c7a00902cfd1f37e3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "50f73ccc63a08335c0352dcbbc56c8410d4b61aa19276f15ff1a22cdf86decec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8dd4f255afc64e51c3b784a69b3c7a3741165c244e69309f4c9c7ff29ad9ab54"
    sha256 cellar: :any,                 arm64_linux:       "cd67c2afea264984259feea992e89867a36a19b995621bf2f5c36f40fbb7bb2e"
    sha256 cellar: :any,                 x86_64_linux:      "835a0adbbc64fec438ec3820a5ff5870278a756402f783c70b8d02462da82175"
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
    require "expect"
    require "pty"

    (testpath/"test.txt").write <<~EOS
      Hello
      world
    EOS
    PTY.spawn(bin/"rura", "--file", "test.txt") do |r, w, pid|
      r.expect "1 Hello"
      w.write "tac\r"
      r.expect "1 world"
      w.write "|sha256sum\r"
      r.expect "1 bdaadfc45abaf"
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

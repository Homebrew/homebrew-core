class Rura < Formula
  desc "Interactive TUI scratchpad for building shell pipelines"
  homepage "https://github.com/tlipinski/rura"
  url "https://github.com/tlipinski/rura/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "349e6895c4390bfb8fbaa788f3954e44ae313493b81e28cd45a8b49030e6cffa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cf08dfc0312a7dc2e0f39037038f6890faf4dd5390ed1f04e22e340cbd3a393"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "127f87d1cb9c611108f8b10235fe355853f6ad342bc75da8654704c2037e8039"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79e89eb4a51b51302428cd60aafb7f9caa1a54c67dd9cae911c8b3e191bdf8bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "e88359673639fab8d3126703dac0480c5be78144575a2698957c2ed8fda51f18"
    sha256 cellar: :any,                 arm64_linux:   "da48bc606bdfdd319f13dc99f7416e559d3ee7d26548dbcb747a92f1b597d405"
    sha256 cellar: :any,                 x86_64_linux:  "b4715e70301ae3052e9832c5de93ccc8006e1e0ba1698e601a041d7bf3b3faab"
  end

  depends_on "rust" => :build

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

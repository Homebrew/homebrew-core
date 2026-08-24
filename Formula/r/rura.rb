class Rura < Formula
  desc "Interactive TUI scratchpad for building shell pipelines"
  homepage "https://github.com/tlipinski/rura"
  url "https://github.com/tlipinski/rura/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "b093146f744f3eb51a6903e37d0b7b36c147b4aa320a8887c3248bfa872f7a99"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d2eaab9d814b86ed769a8d01c6591db429a714618cad7c33a30090eb5609386"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62858c394d6d5a7891c7ad17d4f71038ab2e5b19c62070fb0a023920ea7d08c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a04a9dacb535864652c69d9b52f9bfc6cdc1be54168b9e8721a49d69f19743b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "0139fa3c2c9de2472bc9d7484359ecef29c546297e01b869e89149e4e6f7427d"
    sha256 cellar: :any,                 arm64_linux:   "487bd6a9734633956909a1d8607ba9c837dff6d6fc52acba3a140189bbdef00a"
    sha256 cellar: :any,                 x86_64_linux:  "e14997ecd3354783a163a824a55ca7c8b1fd046304750637a4b577f21f8efdd8"
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

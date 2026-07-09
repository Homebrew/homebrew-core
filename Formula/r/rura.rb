class Rura < Formula
  desc "Interactive TUI scratchpad for building shell pipelines"
  homepage "https://github.com/tlipinski/rura"
  url "https://github.com/tlipinski/rura/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "6716b12debfb9970f82d098fb573ff011b9eab879e0c7b908527bcb4d83bad59"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cc8cb11ba1ac81892bcb71c600aed2df76bfaf8d2e525c44cf106cccab74ce6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de586e2c16806e5ac6625b842129774edcd9e5771aaa1afc4da115b784d8257e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85a80d967e2944f578283329214db2b46546a75841b406a9e01cd33f98d1a13a"
    sha256 cellar: :any_skip_relocation, sonoma:        "71940370f1eb42624e8d9cc9321ac1a3e555a32433d80d2a2e294598418f4c7d"
    sha256 cellar: :any,                 arm64_linux:   "6b3b49fb43e5a55bbbb1fdab9c04e6de206e2f69dfd27bb58592c2a81882bb05"
    sha256 cellar: :any,                 x86_64_linux:  "bc5fd9bc729ed6e407ceb194308cbc98eb3df5d33392fb802930b2be6197ec23"
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

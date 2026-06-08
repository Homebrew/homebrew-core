class Rura < Formula
  desc "Interactive TUI scratchpad for building shell pipelines"
  homepage "https://github.com/tlipinski/rura"
  url "https://github.com/tlipinski/rura/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "796e8c41f1dcfc5687a9b832e8b675c9ecd1a3de8282ad27df1ba56c46db058f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1abc866a4e8707e19d11a1147523fa78109df6b333ff474f49e95ecc374404e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b53a9f0c1f98b5d50c64dcbb63484f9f33741c650993400e7f48b464145583b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec78abb6619ad8ac830dedd203ad71d4ecd9850f2da6bcb9796d7484457e5c95"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a653a20b88a68ce2a18d84176db7558d5b237a539da1231e0142d22a3943b62"
    sha256 cellar: :any,                 arm64_linux:   "47569d7c7b929df031643b7d10a2b4245da113f36255e0fc115e8448d5432f6a"
    sha256 cellar: :any,                 x86_64_linux:  "31465e3f5d0b5990830e1bdc7d9ad0222f7b4f0421dd68677bf01f0bc1d53158"
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

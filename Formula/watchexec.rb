class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/1.13.1.tar.gz"
  sha256 "b58375168233501fbdecad1737053a66eaf3b6c4aef0f5f39bc452a3eefb93d4"

  bottle do
    cellar :any_skip_relocation
    sha256 "68d7edc0ee04c4ca08da96bbb33039343481bfc5cd0bc7a2fe79170477ead26e" => :catalina
    sha256 "70ba21650ecee850450f952746dde08b1dd9db7efd2ae83803c2e60684263576" => :mojave
    sha256 "becd5c5c29c12b4f962b416b0428caece88d221ce2086e11faa73318c6ba396b" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 1
    touch "test"
    sleep 1
    Process.kill("INT", o.pid)
    assert_match "saw file change", o.read
  end
end
